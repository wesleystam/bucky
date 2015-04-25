require 'rails/generators/base'

module Bucky
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def initialize_bucky_configuration_template
        if yes?("Generate a new Buckaroo::Config template?")
          if File.exist? "config/initializers/buckaroo.rb"
            puts "config/initializers/buckaroo.rb already exists. Rename or manually copy the file from templates"
          else
            copy_file "buckaroo.rb", "config/initializers/buckaroo.rb"
          end
        end
      end

      def create_transactions_controller
        if yes?("Generate transactions_controller.rb?")
          if File.exist? "app/controllers/transactions_controller.rb"
            puts "TransactionsController already exists. Rename or manually copy te file from templates."
          else
            copy_file 'transactions_controller.rb', 'app/controllers/transactions_controller.rb'
          end
        end
      end

      def inject_bucky_transactions_into_routes
        if yes?("Inject transaction callback routes in config/routes.rb?")
          insert_into_file "config/routes.rb", before: /^end/ do
            <<-RUBY

  resources :transactions, only: :none do
    member do
      post :callback_success
      post :callback_reject
      post :callback_cancel
      post :callback_error
    end
  end

            RUBY
          end
        end
      end

    end
  end
end
