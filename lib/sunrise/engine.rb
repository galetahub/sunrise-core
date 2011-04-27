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
    
    # Wrap errors in ul->li list and skip labels.
    config.to_prepare do
      ActionView::Base.field_error_proc = Proc.new do |html_tag, instance| 
        if html_tag =~ /<(input|textarea|select)/
          errors = instance.error_message.kind_of?(Array) ? instance.error_message : [instance.error_message]
          errors.collect! { |error| "<li>#{error}</li>" } 
          message = "<ul class='error_box error_box_narrow'>#{errors.join}</ul>".html_safe
          html_tag += message
        end
        
        if html_tag =~ /<label/
          html_tag
        else
          "<div class=\"field_with_errors\">#{html_tag}</div>".html_safe
        end
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
