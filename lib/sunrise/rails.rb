require 'rails'
require 'sunrise-core'
require 'inherited_resources'

module Sunrise
  class Engine < ::Rails::Engine
    config.before_initialize do
      ::ActiveSupport::XmlMini.backend = 'Nokogiri'
      ::InheritedResources.flash_keys = Sunrise.flash_keys
        
      config.i18n.load_path += Dir[File.join(File.dirname(__FILE__), "../../config", 'locales', '**', '*.{rb,yml}').to_s]
      
      ::I18n::Backend::Simple.send(:include, ::I18n::Backend::Pluralization)
      
      #ActiveSupport.on_load :active_record do
      #  ActiveRecord::Base.send :include, Freeberry::MysqlUtils
      #  ActiveRecord::Base.send :include, Freeberry::AccessibleAttributes
      #end
    end
  end
end
