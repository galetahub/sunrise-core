# encoding: utf-8
require 'fileutils'

module Sunrise
  module Utils
    autoload :Header, 'sunrise/utils/header'
    autoload :Mysql, 'sunrise/utils/mysql'
    autoload :Settingslogic, 'sunrise/utils/settingslogic'
    autoload :Transliteration, 'sunrise/utils/transliteration'
    autoload :AccessibleAttributes, 'sunrise/utils/accessible_attributes'
    autoload :I18nBackend, 'sunrise/utils/i18n_backend'
    
    IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg', 'image/tiff', 'image/x-png']
    
    def self.parameterize_filename(filename)
      extension = File.extname(filename)
      basename = filename.gsub(/#{extension}$/, "")
        
      [basename.parameterize('_'), extension].join.downcase
    end
    
    def self.clear_cache
      cache_store = Rails.application.config.action_controller.cache_store
	    cache_store.clear if cache_store
	  
	    FileUtils.rm_r(Dir.glob(Rails.root.join('public', 'cache', '*').to_s), :force => true)
    end
  end
end
