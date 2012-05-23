# coding: utf-8

# PayPal
if Rails.env.production?
  PAYPAL_SANDBOX = "OFF"
else
  PAYPAL_SANDBOX = "ON"
end

# PayPal Recurring
PAYPAL_PERIOD           = :Month  # 周期 ie.) :Month, :Week, :Day
PAYPAL_FREQUENCY        = 1       # 回数
PAYPAL_RECURRING_AMOUNT = 150     # 金額
