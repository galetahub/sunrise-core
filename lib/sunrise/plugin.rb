module Sunrise
  class Plugin
    attr_accessor :name, :model, :menu, :version, :klass, :klass_name
    
    def initialize(name)
      @name = name.to_s.downcase
      @menu = false
      @klass = nil
      @klass_name = nil
      
      Sunrise::Plugins.registered << self
    end
    
    def module_name
      @module_name ||= @name.singularize.camelize.to_sym
    end
    
    def klass
      @klass ||= klass_name.constantize
    end
    
    def klass_name
      @klass_name ||= @name.singularize.camelize
    end
    
    def title
      I18n.t(@name, :scope => [:manage, :plugins])
    end
    
    def self.register(name, &block)
      plugin = self.new(name)

      yield plugin

      raise "A plugin MUST have a name!: #{plugin.inspect}" if plugin.name.blank?
      
      plugin.version ||= Sunrise::VERSION.dup
      
      if plugin.model
        [plugin.model].flatten.each do |model|
          module_name = plugin.module_name
          model_path = "sunrise/models/#{plugin.name}"
          
          case model
            when String then model_path = model
            when Symbol then 
              model_name = model.to_s.singularize
              module_name = model_name.camelize.to_sym
              model_path = "sunrise/models/#{model_name}"
          end
          
          Sunrise::Models.send(:autoload, module_name, model_path)
        end
      end
      
    end
  end
  
end
