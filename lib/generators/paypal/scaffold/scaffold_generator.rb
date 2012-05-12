# coding: utf-8
require 'rails/generators'

module Paypal
  module Generators
    class ScaffoldGenerator < ::Rails::Generators::Base

      source_root File.expand_path("../templates", __FILE__)
      desc "This generator scaffold for PayPal"
      
      def generate_scaffold
        # App
        copy_file "app/models/paypal_api.rb", "app/models/paypal_api.rb"
        
        # Config
        if File.exist?('config/initializers/local_setting.rb')
          content = "\n# PayPal\n"
          content += "ENV['PAYPAL_SANDBOX']   = \"ON\"\n"
          content += "ENV['PAYPAL_USER_NAME'] = \"test01_1336296393_biz_api1.gmail.com\"\n"
          content += "ENV['PAYPAL_PASSWORD']  = \"1336296414\"\n"
          content += "ENV['PAYPAL_SIGNATURE'] = \"AiPC9BjkCyDFQXbSkoZcgqH3hpacAzpTbNTAkYEP8T8QC6kv0aF-gRj-\"\n"
          content += "ENV['PAYPAL_PERIOD']    = \"Month\"   # 周期 ie.) :Month, :Week, :Day\n"
          content += "ENV['PAYPAL_FREQUENCY'] = \"1\"       # 回数\n"
          content += "ENV['PAYPAL_AMOUNT']    = \"150\"     # 金額\n"
          
          append_file "config/initializers/local_setting.rb", content.force_encoding('ASCII-8BIT')
        else
          copy_file "config/initializers/local_setting.rb", "config/initializers/local_setting.rb"
        end
      end
    end
  end
end
