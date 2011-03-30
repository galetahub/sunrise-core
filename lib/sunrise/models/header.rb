# encoding: utf-8
module Sunrise
  module Models
    module Header
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend,  ClassMethods
      end
      
      module ClassMethods
        def self.extended(base)
          base.class_eval do
            belongs_to :headerable, :polymorphic => true
          end
        end
      end
      
      module InstanceMethods
      end
    end
  end
end
