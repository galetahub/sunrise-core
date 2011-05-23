require 'rails/generators'
require 'rails/generators/migration'

module Sunrise
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      
      desc "Creates a Sunrise initializer and copy general files to your application."
      
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      class_option :migrations, :type => :boolean, :default => true, :description => "Generate migrations files"
      
      # copy images
      def copy_images
        directory "images/manage", "public/images/manage"
      end
      
      # copy javascripts
      def copy_javascripts
        directory "javascripts", "public/javascripts"
      end
      
      # copy stylesheets
      def copy_stylesheets
        directory "stylesheets", "public/stylesheets"
      end
      
      # copy views
      def copy_views
        directory "views", "app/views"
      end
      
      def copy_configurations
        copy_file('config/seeds.rb', 'db/seeds.rb')
        copy_file('config/sunrise.rb', 'config/initializers/sunrise.rb')
        
        template('config/application.yml', 'config/application.yml.sample')
        template('config/database.yml', 'config/database.yml.sample')
        template('config/logrotate-config', 'config/logrotate-config.sample')
        template('config/nginx-config-passenger', 'config/nginx-config-passenger.sample')
      end
      
      def copy_helpers
        directory('helpers', 'app/helpers')
      end
      
      # copy models
      def copy_models
        directory "models", "app/models"
      end
      
      def copy_sweepers
        directory "sweepers", "app/sweepers"
      end
      
      def download_rails_js
        say_status("fetching rails.js", "", :green)
        get "https://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"
      end
      
      # copy migration files
      def create_migrations
        if options.migrations
          [:users, :roles, :structures, :pages, :assets, :headers].each do |item|
            migration_template "migrate/create_#{item}.rb", File.join('db/migrate', "sunrise_create_#{item}.rb")
          end
        end
      end
      
      def dependent_generators
        say_status("invoke dependent generators", "", :green)
        
        generate("simple_form:install")
        generate("sunrise:file_upload:install")
        generate("devise:install")
      end
      
      # Add devise routes
      def add_routes
        route "devise_for :users"
        route "resources :pages, :only => [:show]"
        route 'root :to => "welcome#index"'
      end
      
      def autoload_paths
        log :autoload_paths, "models/defaults and app/sweepers"
        sentinel = /\.autoload_paths\s+\+=\s+\%W\(\#\{config\.root\}\/extras\)\s*$/

        code = 'config.autoload_paths += %W(#{config.root}/app/models/defaults #{config.root}/app/sweepers)'
          
        in_root do
          inject_into_file 'config/application.rb', "    #{code}\n", { :after => sentinel, :verbose => false }
        end
      end
      
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          current_time.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
      
      def self.current_time
        @current_time ||= Time.now
        @current_time += 1.minute
      end
      
      protected
        
        def app_name
          @app_name ||= defined_app_const_base? ? defined_app_name : File.basename(destination_root)
        end

        def defined_app_name
          defined_app_const_base.underscore
        end

        def defined_app_const_base
          Rails.respond_to?(:application) && defined?(Rails::Application) &&
            Rails.application.is_a?(Rails::Application) && Rails.application.class.name.sub(/::Application$/, "")
        end

        alias :defined_app_const_base? :defined_app_const_base

        def app_const_base
          @app_const_base ||= defined_app_const_base || app_name.gsub(/\W/, '_').squeeze('_').camelize
        end

        def app_const
          @app_const ||= "#{app_const_base}::Application"
        end
        
        def app_path
          @app_path ||= Rails.root.to_s
        end
    end
  end
end
