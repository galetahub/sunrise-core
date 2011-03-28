module Sunrise
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      
      desc "Creates a Sunrise initializer and copy general files to your application."
      
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
      
      # copy sweepers
      def copy_sweepers
        directory "sweepers", "app/sweepers"
      end
      
      def copy_configurations
        copy_file('config/words', 'config/words')
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
