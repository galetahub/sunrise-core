require 'rails'
require 'sunrise-core'

module Sunrise
  class Engine < ::Rails::Engine
    config.before_initialize do
      ActiveSupport::XmlMini.backend = 'Nokogiri'
      InheritedResources.flash_keys = Sunrise.flash_keys
        
      config.i18n.load_path += Dir[File.join(File.dirname(__FILE__), "../../config", 'locales', '**', '*.{rb,yml}').to_s]
      
      I18n::Backend::Simple.send(:include, ::I18n::Backend::Pluralization)
      
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send :include, Sunrise::Utils::Mysql
        ActiveRecord::Base.send :include, Sunrise::Utils::AccessibleAttributes
      end
    end
    
    config.after_initialize do
      ActionController::Base.send :include, Sunrise::Controllers::HeadOptions
      ActionView::Base.send :include, Sunrise::Views::Helpers
      
      Paperclip.interpolates('basename') do |attachment, style|
        filename = attachment.original_filename.gsub(/#{File.extname(attachment.original_filename)}$/, "")
        Sunrise::Utils.parameterize_filename( filename )
      end
    end
    
    # For railties migrations rake
    def railtie_name
      'sunrise'
    end
  end
end
