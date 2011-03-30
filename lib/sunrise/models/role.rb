# encoding: utf-8
module Sunrise
  module Models
    module Role
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend,  ClassMethods
      end
      
      module ClassMethods
        def self.extended(base)
          base.class_eval do
            belongs_to :user
        
            enumerated_attribute :role_type, :id_attribute => :role_type
            attr_accessible :role_type
          end
        end
      end
      
      module InstanceMethods
        def to_sym
          role_type.code
        end
      end
    end
  end
end
