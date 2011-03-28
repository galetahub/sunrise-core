# encoding: utf-8
require 'sunrise/core_ext'

module Sunrise
  
  # Custom flash_keys
  mattr_accessor :flash_keys
  @@flash_keys = [ :success, :failure ]
  
  # Default way to setup Devise. Run rails generate devise_install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end

require 'sunrise/rails'
