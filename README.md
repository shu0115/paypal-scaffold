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

#### PaypalApi.cancel_recurring

#### PaypalApi.adaptive_payment

#### PaypalApi.mass_pay

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 Shun Matsumoto. <a href="http://creativecommons.org/licenses/by-nc-sa/2.1/jp/" target="_blank">CC BY-NC-SA 2.1</a>
