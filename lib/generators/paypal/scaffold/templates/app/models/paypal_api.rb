# coding: utf-8
class PaypalApi
  
  private
  
  # PayPal Setting
  Paypal.sandbox   = ENV['PAYPAL_SANDBOX'] == "ON" ? true : false
  PAYPAL_USER_NAME = ENV['PAYPAL_USER_NAME']
  PAYPAL_PASSWORD  = ENV['PAYPAL_PASSWORD']
  PAYPAL_SIGNATURE = ENV['PAYPAL_SIGNATURE']
  PAYPAL_PERIOD    = ENV['PAYPAL_PERIOD'].to_sym     # 周期
  PAYPAL_FREQUENCY = ENV['PAYPAL_FREQUENCY'].to_i  # 回数
  PAYPAL_AMOUNT    = ENV['PAYPAL_AMOUNT'].to_i     # 金額

  #------------------#
  # self.get_request #
  #------------------#
  # リクエスト生成
  def self.get_request
    request = Paypal::Express::Request.new(
      username:  PAYPAL_USER_NAME,
      password:  PAYPAL_PASSWORD,
      signature: PAYPAL_SIGNATURE,
    )
    
    return request
  end

  #---------------------------#
  # self.set_express_checkout #
  #---------------------------#
  # チェックアウト開始
  # IN  : success_calback - 成功時のリダイレクト先URL
  #     : cancel_calback - キャンセル時のリダイレクト先URL
  #     : description - チェックアウトの説明(create_recurring - Paypal::Payment::Recurringのdescriptionに渡す値と同じでなければならない)
  # OUT : response.redirect_uri - チェックアウト開始用PayPal側URL
#  def self.set_express_checkout( success_calback_url, cancel_calback_url )
  def self.set_express_checkout( args )
    success_calback = args[:success_calback]
    cancel_calback  = args[:cancel_calback]
    description     = args[:description]
    
    request = self.get_request
    
    payment_request = Paypal::Payment::Request.new(
      currency_code:                 :JPY, # if nil, PayPal use USD as default
      billing_type:                  :RecurringPayments,
      billing_agreement_description: description,
    )
    
    response = request.setup(
      payment_request,
      success_calback,
      cancel_calback,
    )
    
    return response.redirect_uri
  end
  
  #-----------------------#
  # self.create_recurring #
  #-----------------------#
  # プロフィール作成
  # IN  : token - PayPalからリダイレクトで帰って来た時のparams[:token]から取得
  # OUT : response.recurring.identifier # => profile_id
  def self.create_recurring( token, description )
    request = self.get_request
    
    profile = Paypal::Payment::Recurring.new(
      start_date: Time.now,
      description: description,
      billing: {
        period:        PAYPAL_PERIOD,
        frequency:     PAYPAL_FREQUENCY,
        amount:        PAYPAL_AMOUNT,
        currency_code: :JPY, # if nil, PayPal use USD as default
      }
    )
    
    response = request.subscribe!( token, profile )
    response.recurring
    
    return response.recurring.identifier # => profile_id
  end

  #----------------------------#
  # self.get_recurring_profile #
  #----------------------------#
  # プロフィール取得
  # IN  : profile_id
  # OUT : response.recurring
  def self.get_recurring_profile( profile_id )
    request = self.get_request
    response = request.subscription(profile_id)
    
    return response.recurring
  end

  #-----------------------#
  # self.cancel_recurring #
  #-----------------------#
  # キャンセル
  # IN  : profile_id
  # OUT : response.ack - "Success" OR Others
  def self.cancel_recurring( profile_id )
    request = self.get_request
    response = request.renew!( profile_id, :Cancel )
    
    return response.ack
  end
  
end
