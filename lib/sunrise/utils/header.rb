# encoding: utf-8
module Sunrise
  module Utils
    module Header
      def self.included(base)
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
      end
      
      module ClassMethods
        def self.extended(base)
          base.class_eval do
            has_one :header, :as => :headerable, :dependent => :delete
            
            attr_accessible :header_attributes
            
            accepts_nested_attributes_for :header, :reject_if => :all_blank
          end
        end
      end
      
      module InstanceMethods
        def default_header
          header || build_header
        end
      end
    end
  end
end
