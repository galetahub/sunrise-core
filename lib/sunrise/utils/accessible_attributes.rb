# encoding: utf-8
module Sunrise
  module Utils
    module AccessibleAttributes
      def self.included(base)
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
      end
      
      module ClassMethods
        def self.extended(base)  
          base.class_eval do
            attr_accessible
            attr_accessor :accessible
          end
        end
      end
      
      module InstanceMethods
        private
    
          def mass_assignment_authorizer
            if accessible == :all
              self.class.protected_attributes
            else
              super + (accessible || [])
            end
          end
      end
    end
  end
end
