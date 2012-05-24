# PayPal Scaffold

Scaffold for PayPal API.

## Installation

Edit: Gemfile

```ruby
gem 'paypal-scaffold'
```

Execute:

    bundle

Or install it yourself as:

    gem install paypal-scaffold

## Usage

Generate paypal scaffold:

    rails g paypal:scaffold

PayPal Setting

[ Common ]

Edit: config/initializers/constants.rb

```ruby
# PayPal
if Rails.env.production?
  PAYPAL_SANDBOX = "OFF"
else
  PAYPAL_SANDBOX = "ON"
end

# PayPal Recurring
PAYPAL_RECURRING_PERIOD    = :Month  # 周期 ie.) :Month, :Week, :Day
PAYPAL_RECURRING_FREQUENCY = 1       # 回数
PAYPAL_RECURRING_AMOUNT    = 150     # 金額
```

[ Development ]

<a href="https://developer.paypal.com/cgi-bin/devscr?cmd=_certs-session" target="_blank">API Credentials</a>

Edit: config/initializers/local_setting.rb

```ruby
# PayPal
ENV['PAYPAL_USER_NAME'] = "YOUR API Username"
ENV['PAYPAL_PASSWORD']  = "YOUR API Password"
ENV['PAYPAL_SIGNATURE'] = "YOUR Signature"
```

[ Production ]

<a href="https://www.paypal.com/jp/cgi-bin/webscr?cmd=_profile-api-signature" target="_blank">API署名の表示または削除</a>

Heroku: config:add

    heroku config:add PAYPAL_USER_NAME=YOUR_API_USERNAME
    heroku config:add PAYPAL_PASSWORD=YOUR_API_PASSWORD
    heroku config:add PAYPAL_SIGNATURE=YOUR_SIGNATURE

## Method Call Sample

### ----- Recurring Payments API -----

#### PaypalApi.set_express_checkout

```ruby
success_calback_url = request.url
cancel_calback_url  = url_for( controller: "top", action: "index", id: params[:id] )
description         = "定期購読支払い"

# PayPal取引開始
redirect_uri = PaypalApi.set_express_checkout( success_calback_url, cancel_calback_url, description )

redirect_to redirect_uri and return
```

#### PaypalApi.create_recurring

```ruby
token = params[:token]

# PayPal定期支払作成
profile_id = PaypalApi.create_recurring( token )

if profile_id.blank?
  redirect_to( { action: "index" }, alert: "ERROR!!" )
end
```

#### PaypalApi.get_recurring_profile

```ruby
@recurring = PaypalApi.get_recurring_profile( profile_id )

unless @recurring.try(:status) == "Active"
  flash.now[:alert] = "PayPalステータスが有効ではありません。"
end
```

```erb
<b>PayPalステータス:</b><br />
status：<%= @recurring.status %><br />
start_date：<%= Time.parse( @recurring.start_date ).strftime("%Y/%m/%d %H:%M:%S") rescue "" %><br />
description：<%= @recurring.description %><br />
name：<%= @recurring.name %><br />
billing - amount total：<%= @recurring.billing.amount.total %>／period：<%= @recurring.billing.period %>／frequency：<%= @recurring.billing.frequency %>／currency_code：<%= @recurring.billing.currency_code %><br />
regular_billing - amount total：<%= @recurring.regular_billing.amount.total %>／period：<%= @recurring.regular_billing.period %>／frequency：<%= @recurring.regular_billing.frequency %>／currency_code：<%= @recurring.regular_billing.currency_code %><br />
summary - next_billing_date：<%= Time.parse( @recurring.summary.next_billing_date ).strftime("%Y/%m/%d %H:%M:%S") rescue "" %>／cycles_completed：<%= @recurring.summary.cycles_completed %>／cycles_remaining：<%= @recurring.summary.cycles_remaining %>／outstanding_balance：<%= @recurring.summary.outstanding_balance %>／failed_count：<%= @recurring.summary.failed_count %>／last_payment_date：<%= @recurring.summary.last_payment_date %>／last_payment_amount：<%= @recurring.summary.last_payment_amount %><br />
```

#### PaypalApi.cancel_recurring

```ruby
response = PaypalApi.cancel_recurring( profile_id )

if response == "Success"
  notice = "PayPalのキャンセルが完了しました。"
else
  alert = "PayPalのキャンセルに失敗しました。"
end

redirect_to( { action: "index" }, notice: notice, alert: alert )
```

### ----- Adaptive Payments API -----

#### PaypalApi.adaptive_payment

```ruby
return_url = url_for( controller: "top", action: "index", result: "Success" )
cancel_url = url_for( controller: "top", action: "index", result: "Cancel" )

receiver_list =[
  { "email" => "email01@email.com", "amount" => 100 },
  { "email" => "email02@email.com", "amount" => 200 },
]

result, response = PaypalApi.adaptive_payment( return_url, cancel_url, receiver_list )

if result == "Success"
  redirect_to response and return
else
  flash.now[:alert] = "PayPal接続に失敗しました。\n#{response}"
end
```

### ----- MassPay API -----

#### PaypalApi.mass_pay

```ruby
receive_list = [
  { email: "email01@email.com", amount: 100 },
  { email: "email02@email.com", amount: 200 },
  { email: "email03@email.com", amount: 300 },
]

result_hash = PaypalApi.mass_pay( receive_list )

if result_hash["ACK"] == "Success"
  flash.now[:notice] = "支払いが完了しました。"
else
  flash.now[:alert] = "支払いに失敗しました。"
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 Shun Matsumoto. <a href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/" target="_blank">CC BY-NC-SA 2.1</a>
