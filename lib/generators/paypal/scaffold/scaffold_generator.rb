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
          content = "# PayPal\n"
          content = "ENV['PAYPAL_SANDBOX']   = \"ON\"\n"
          
          insert_into_file "config/initializers/local_setting.rb", content
          
#          insert_into_file "app/assets/javascripts/application.js", "//= require twitter/bootstrap\n", :after => "jquery_ujs\n"
#          append_file "config/initializers/local_setting.rb", "config/initializers/local_setting.rb"
=begin
          append_file 'config/initializers/local_setting.rb' do
            '# PayPal'
            'ENV["PAYPAL_SANDBOX"]   = "ON"'
            'ENV["PAYPAL_USER_NAME"] = "test01_1336296393_biz_api1.gmail.com"'
            'ENV["PAYPAL_PASSWORD"]  = "1336296414"'
            'ENV["PAYPAL_SIGNATURE"] = "AiPC9BjkCyDFQXbSkoZcgqH3hpacAzpTbNTAkYEP8T8QC6kv0aF-gRj-"'
            # 'ENV["PAYPAL_PERIOD"]    = "Month"  # 周期 ie.) :Month, :Week, :Day'
            # 'ENV["PAYPAL_FREQUENCY"] = "1"       # 回数'
            # 'ENV["PAYPAL_AMOUNT"]    = "150"     # 金額'
            'ENV["PAYPAL_PERIOD"]    = "Month"'
            'ENV["PAYPAL_FREQUENCY"] = "1"'
            'ENV["PAYPAL_AMOUNT"]    = "150"'
          end
=end
        else
#          copy_file "application.js", "app/assets/javascripts/application.js"
          copy_file "config/initializers/local_setting.rb", "config/initializers/local_setting.rb"
        end
        
=begin
        # Config
        copy_file "config/initializers/omniauth.rb", "config/initializers/omniauth.rb"
        copy_file "config/initializers/local_setting.rb", "config/initializers/local_setting.rb"
        copy_file "config/initializers/constants.rb", "config/initializers/constants.rb"
        
        insert_into_file "config/routes.rb", "  match \"/auth/:provider/callback\" => \"sessions#callback\"\n  match \"/auth/failure\" => \"sessions#failure\"\n  match \"/logout\" => \"sessions#destroy\", :as => :logout\n", after: "# first created -> highest priority.\n"
        insert_into_file "config/routes.rb", "  root to: 'top#index'\n", after: "# root :to => 'welcome#index'\n"
        insert_into_file "config/routes.rb", "  match ':controller(/:action(/:id))(.:format)'\n", after: "# match ':controller(/:action(/:id))(.:format)'\n"
        insert_into_file "config/application.rb", "    config.time_zone = 'Tokyo'\n    config.active_record.default_timezone = :local\n", after: "# config.time_zone = 'Central Time (US & Canada)'\n"
        insert_into_file "config/application.rb", "    config.i18n.default_locale = :ja\n", after: "# config.i18n.default_locale = :de\n"
        
        copy_file "config/locales/ja.yml", "config/locales/ja.yml"
        
        # DB
        copy_file "db/migrate/create_users.rb", "db/migrate/20000101000000_create_users.rb"
        
        # App
        copy_file "app/models/user.rb", "app/models/user.rb"
        
        copy_file "app/controllers/sessions_controller.rb", "app/controllers/sessions_controller.rb"
        copy_file "app/controllers/application_controller.rb", "app/controllers/application_controller.rb"
        copy_file "app/controllers/top_controller.rb", "app/controllers/top_controller.rb"
        
        copy_file "app/views/layouts/application.html.erb", "app/views/layouts/application.html.erb"
        copy_file "app/views/top/index.html.erb", "app/views/top/index.html.erb"
        
        copy_file "app/assets/stylesheets/base.css.scss", "app/assets/stylesheets/base.css.scss"
        copy_file "app/assets/stylesheets/scaffolds.css.scss", "app/assets/stylesheets/scaffolds.css.scss"
        
        # public
        remove_file 'public/index.html'
        
        # README
        remove_file 'README.rdoc'
        copy_file "README.md", "README.md"
        
        # gitignore
        insert_into_file ".gitignore", "\n# Add\n.DS_Store\n/config/initializers/local_setting.rb\n", after: "/tmp\n"
=end
      end
    end
  end
end
