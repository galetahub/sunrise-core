# encoding: utf-8
module Sunrise
  module CarrierWave
    module Glue
      def self.included(base)
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
      end
      
      module ClassMethods
        def sunrise_uploader(uploader=nil, options={}, &block)
          options = { :mount_on => :data_file_name }.merge(options)
          
          mount_uploader(:data, uploader, options, &block)
        end
      end
      
      module InstanceMethods
        
      end
    end
  end
end
