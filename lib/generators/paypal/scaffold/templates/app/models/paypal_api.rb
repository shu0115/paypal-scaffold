# coding: utf-8
class PaypalApi
  
  private
  
  # PayPal Setting
  Paypal.sandbox   = PAYPAL_SANDBOX == "ON" ? true : false
  PAYPAL_USER_NAME = ENV['PAYPAL_USER_NAME']
  PAYPAL_PASSWORD  = ENV['PAYPAL_PASSWORD']
  PAYPAL_SIGNATURE = ENV['PAYPAL_SIGNATURE']

  # MassPay Setting
  MASS_PAY_ENDPOINT = PAYPAL_SANDBOX == "ON" ? "https://api-3t.sandbox.paypal.com" : "https://api-3t.paypal.com"  # 接続先

  # ----- Recurring Payments API ----- #
  #------------------#
  # self.get_request #
  #------------------#
  # リクエスト生成
  # OUT : request - PayPalリクエスト
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
  # IN  : success_calback       - 成功時のリダイレクト先URL
  #     : cancel_calback        - キャンセル時のリダイレクト先URL
  #     : description           - チェックアウトの説明(create_recurringのdescriptionと同じでなければならない)
  # OUT : response.redirect_uri - チェックアウト開始用PayPal側URL
  def self.set_express_checkout( success_calback, cancel_calback, description )
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
  # 定期購読プロフィール作成
  # IN  : token                         - PayPalからリダイレクトで帰って来た時のparams[:token]から取得
  #     : description                   - チェックアウトの説明(set_express_checkoutのdescriptionと同じでなければならない)
  # OUT : response.recurring.identifier - profile_id
  def self.create_recurring( token, description )
    request = self.get_request
    
    profile = Paypal::Payment::Recurring.new(
      start_date: Time.now,
      description: description,
      billing: {
        period:        PAYPAL_RECURRING_PERIOD,
        frequency:     PAYPAL_RECURRING_FREQUENCY,
        amount:        PAYPAL_RECURRING_AMOUNT,
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
  # 定期購読プロフィール取得
  # IN  : profile_id         - create_recurringの戻り値
  # OUT : response.recurring - 定期購読の状態
  def self.get_recurring_profile( profile_id )
    request = self.get_request
    response = request.subscription(profile_id)
    
    return response.recurring
  end

  #-----------------------#
  # self.cancel_recurring #
  #-----------------------#
  # 定期購読キャンセル
  # IN  : profile_id   - create_recurringの戻り値
  # OUT : response.ack - "Success" OR Others
  def self.cancel_recurring( profile_id )
    request = self.get_request
    response = request.renew!( profile_id, :Cancel )
    
    return response.ack
  end
  # ----- ／ Recurring Payments API ----- #
  
  # ----- Adaptive Payments API ----- #
  #-----------------------#
  # self.adaptive_payment #
  #-----------------------#
  # IN  : return_url    - 成功時のリダイレクト先URL
  #     : cancel_url    - キャンセル時のリダイレクト先URL
  #     : receive_list  - 支払い先email／amountリスト
  # OUT : Result(One)   - "Success" OR "Error"
  #     : Response(Two) - 決済用PayPal URL OR エラーメッセージ
  def self.adaptive_payment( return_url, cancel_url, receiver_list )
    pay_request = PaypalAdaptive::Request.new
    
    data = {
      "returnUrl"       => return_url,
      "requestEnvelope" => { "errorLanguage" => "ja_JP" },
      "currencyCode"    => "JPY",
      "receiverList"    => { "receiver" => receiver_list },
      "cancelUrl"       => cancel_url,
      "actionType"      => "PAY",
    }
    
    pay_response = pay_request.pay( data )
  
    if pay_response.success?
      return "Success", pay_response.approve_paypal_payment_url
    else
      return "Error", pay_response.errors.first['message']
    end
  end
  # ----- ／ Adaptive Payments API ----- #

  # ----- MassPay API ----- #
  #---------------#
  # self.mass_pay #
  #---------------#
  # 一括支払い
  # IN  : receive_list - 支払い先email／amountリスト
  # OUT : decode_hash  - API結果ハッシュ
  def self.mass_pay( receive_list )
    # リクエストパラメータ設定
  	request_param = {
  	  "USER"         => PAYPAL_USER_NAME,
  	  "PWD"          => PAYPAL_PASSWORD,
  	  "SIGNATURE"    => PAYPAL_SIGNATURE,
  	  "METHOD"       => "MassPay",
  	  "CURRENCYCODE" => "JPY",
  	  "RECEIVERTYPE" => "EmailAddress",
  	  "VERSION"      => "89.0",
  	}

    # 支払い先リスト
    receive_list.each.with_index{ |receive, index|
      request_param["L_EMAIL#{index}"] = receive[:email].to_s
      request_param["L_AMT#{index}"]   = receive[:amount].to_s
    }

  	url = URI.parse( MASS_PAY_ENDPOINT )
  	http = Net::HTTP.new( url.host, url.port )
  	http.use_ssl = true
    
    # パラメータ文字列化
  	string_field_params = request_param.map{ |p| "#{p.first}=#{CGI.escape(p.last)}" }.join("&")
    
    # POST実行
  	response = http.post( "/nvp", string_field_params )
    
    # レスポンスハッシュ化
    decode_hash = Hash[ URI.decode_www_form( response.body ) ]

    # 結果ハッシュを返す
    return decode_hash
  end
  # ----- ／ MassPay API ----- #
  
end
