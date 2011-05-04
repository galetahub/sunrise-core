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
        def empty?
          [keywords, description, title].map(&:blank?).all?
        end

        def has_info?
          !empty?
        end

        def read(key)
          value = read_attribute(key)
          value.blank? ? nil : value
        end
      end
    end
  end
end
