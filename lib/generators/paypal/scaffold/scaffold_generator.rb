# coding: utf-8
require 'rails/generators'

module Paypal
  module Generators
    class ScaffoldGenerator < ::Rails::Generators::Base

      source_root File.expand_path( "../templates", __FILE__ )
      desc "This generator scaffold for PayPal"
      
      def generate_scaffold
        # ----- App ----- #
        copy_file "app/models/paypal_api.rb", "app/models/paypal_api.rb"
        
        # ----- Config ----- #
        # initializers/local_setting.rb
        if File.exist?( 'config/initializers/local_setting.rb' )
          content = "\n# PayPal\n"
          content += "ENV['PAYPAL_USER_NAME'] = \"YOUR API Username\"\n"
          content += "ENV['PAYPAL_PASSWORD']  = \"YOUR API Password\"\n"
          content += "ENV['PAYPAL_SIGNATURE'] = \"YOUR Signature\"\n"
          
          append_file( "config/initializers/local_setting.rb", content.force_encoding('ASCII-8BIT') )
        else
          copy_file( "config/initializers/local_setting.rb", "config/initializers/local_setting.rb" )
        end
        
        # initializers/constants.rb
        if File.exist?( 'config/initializers/constants.rb' )
          content = "\n# PayPal\n"
          content += "if Rails.env.production?\n"
          content += "  PAYPAL_SANDBOX = \"OFF\"\n"
          content += "else\n"
          content += "  PAYPAL_SANDBOX = \"ON\"\n"
          content += "end\n"
          content = "\n# PayPal Recurring\n"
          content += "PAYPAL_PERIOD           = :Month  # 周期 ie.) :Month, :Week, :Day\n"
          content += "PAYPAL_FREQUENCY        = 1       # 回数\n"
          content += "PAYPAL_RECURRING_AMOUNT = 150     # 金額\n"
          
          append_file( "config/initializers/constants.rb", content.force_encoding('ASCII-8BIT') )
        else
          copy_file( "config/initializers/constants.rb", "config/initializers/constants.rb" )
        end
      end
    end
  end
end
