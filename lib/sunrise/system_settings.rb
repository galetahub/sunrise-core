# encoding: utf-8
require 'ostruct'

module Sunrise
  class SystemSettings < Utils::Settingslogic
    source Rails.root.join("config", "application.yml")
    #namespace (Rails.env.to_s || 'development')
    
    class << self
      def ostruct
        instance.serialize
      end
      
      def update_settings(attributes)
        instance.update attributes
        instance.save
      end
      
      def write(hash)
        begin
          File.open(source, 'w') do |file|
            file.write hash.to_yaml
          end
        rescue Exception => e
          return false
        end
      end
      
      def hashes_to_openstructs(obj, memo={})
        return obj unless Hash === obj
        
        memo[obj.object_id] ||= OpenStruct.new( Hash[
            *obj.inject( [] ) { |a, (k, v)|
              a.push k, hashes_to_openstructs( v, memo )
            }
          ])
      end
    end
    
    def save
      if self.class.namespace
        hash = YAML.load(ERB.new(File.read(self.class.source)).result).to_hash
        hash[self.class.namespace] ||= {}
        hash[self.class.namespace].update self
      else
        hash = self
      end
        
      self.class.write(hash)
      reload
    end
    
    def reload
      @instance = nil
      @struct = nil
      
      return true
    end
    
    def serialize
      @struct ||= self.class.hashes_to_openstructs(self)   
      @struct
    end
  end
end
