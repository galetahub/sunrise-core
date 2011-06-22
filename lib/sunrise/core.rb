# encoding: utf-8
require 'sunrise/core_ext'

module Sunrise
  autoload :SystemSettings, 'sunrise/system_settings'
  autoload :ModelFilter, 'sunrise/model_filter'  
  autoload :Plugins, 'sunrise/plugins'
  autoload :Plugin, 'sunrise/plugin'
  
  module Models
    autoload :RoleType,      'sunrise/models/role_type'
    autoload :StructureType, 'sunrise/models/structure_type'
    autoload :PositionType,  'sunrise/models/position_type'
    autoload :Role,          'sunrise/models/role'
    autoload :Header,        'sunrise/models/header'
  end
  
  module Controllers
    autoload :HeadOptions, 'sunrise/controllers/head_options'
  end
  
  module Views
    autoload :Helpers, 'sunrise/views/helpers'
    autoload :FormBuilder, 'sunrise/views/form_builder'
  end
  
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
  end
  
  module NestedSet
    autoload :Descendants, 'sunrise/nested_set/descendants'
    autoload :Depth, 'sunrise/nested_set/depth'
  end
  
  # Custom flash_keys
  mattr_accessor :flash_keys
  @@flash_keys = [ :success, :failure ]
  
  mattr_accessor :available_locales
  @@available_locales = []
  
  mattr_accessor :title_spliter
  @@title_spliter = ' – '
  
  mattr_accessor :field_error_proc
  @@field_error_proc = Proc.new do |html_tag, instance| 
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
  
  # Default way to setup Devise. Run rails generate devise_install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end

require 'sunrise/version'
require 'sunrise/core_plugins'
require 'sunrise/engine'
