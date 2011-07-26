require 'rails'
require 'awesome_nested_set'
require 'inherited_resources'
require 'paperclip'
require 'sunrise-core'
require 'sunrise-file-upload'

module Sunrise
  class Engine < ::Rails::Engine
    config.i18n.load_path += Dir[File.join(File.dirname(__FILE__), "../../config", 'locales', '**', '*.{rb,yml}').to_s]
    config.autoload_paths << File.expand_path("../../../app/sweepers", __FILE__)
    
    initializer "sunrise.core.setup" do
      ActiveSupport::XmlMini.backend = 'Nokogiri'
      InheritedResources.flash_keys = Sunrise.flash_keys
        
      I18n.backend = Sunrise::Utils::I18nBackend.new
      
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send :include, Sunrise::Utils::Mysql
        ActiveRecord::Base.send :include, Sunrise::Utils::AccessibleAttributes
      end
      
      ActiveSupport.on_load :action_controller do
        ActionController::Base.send :include, Sunrise::Controllers::HeadOptions
      end
      
      ActiveSupport.on_load :action_view do
        ActionView::Base.send :include, Sunrise::Views::Helpers
      end
    end
    
    initializer "sunrise.core.awesome_nested_set" do
      CollectiveIdea::Acts::NestedSet::Model.send :include, Sunrise::NestedSet::Depth
      CollectiveIdea::Acts::NestedSet::Model::InstanceMethods.send :include, Sunrise::NestedSet::Descendants
    end
    
    # Wrap errors in ul->li list and skip labels.
    config.to_prepare do
      ActionView::Base.field_error_proc = Sunrise.field_error_proc
    end
    
    config.after_initialize do
      Paperclip.interpolates('basename') do |attachment, style|
        filename = attachment.original_filename.gsub(/#{File.extname(attachment.original_filename)}$/, "")
        Sunrise::Utils.parameterize_filename( filename )
      end
      
      Sunrise::FileUpload::Manager.before_create do |env, asset|
        asset.user = env['warden'].user if env['warden']
      end
    end
    
    # For railties migrations rake
    def railtie_name
      'sunrise'
    end
  end
end
