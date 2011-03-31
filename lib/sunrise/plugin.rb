module Sunrise
  class Plugin
    attr_accessor :name, :model, :menu, :version, :klass
    
    def initialize(name)
      @name = name.to_s.downcase
      @menu = false
      @klass = nil
      
      Sunrise::Plugins.registered << self
    end
    
    def module_name
      @module_name ||= @name.singularize.camelize.to_sym
    end
    
    def klass
      @klass ||= @name.singularize.camelize.constantize
    end
    
    def title
      I18n.t(@name, :scope => [:manage, :plugins])
    end
    
    def self.register(name, &block)
      plugin = self.new(name)

      yield plugin

      raise "A plugin MUST have a name!: #{plugin.inspect}" if plugin.name.blank?

      if plugin.model
        model_path = (plugin.model == true ? "sunrise/models/#{plugin.name}" : plugin.model)
        Sunrise::Models.send(:autoload, plugin.module_name, model_path)
      end
    end
  end
  
end
