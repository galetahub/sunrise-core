# encoding: utf-8
module Sunrise
  module Models
    module Page
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend,  ClassMethods
      end
      
      module ClassMethods
        def self.extended(base)
          base.class_eval do
            belongs_to :structure
            validates_presence_of :title, :content
          end
        end
      end
      
      module InstanceMethods
        def content_without_html
          return nil if self.content.blank?
          self.content.no_html
        end
      end
    end
  end
end
