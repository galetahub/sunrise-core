# encoding: utf-8
module Sunrise
  module Controllers
    module Manage
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend,  ClassMethods
      end
      
      module ClassMethods
        def self.extended(base)
          base.class_eval do
            prepend_before_filter :authenticate_user!
            check_authorization
            
            layout "manage"
            respond_to :html
            
            class_attribute :orders_configuration, :instance_writer => false
            
            helper_method :search_filter
          end
        end
        
        def order_by(*orders)
          options = orders.extract_options!
          options.symbolize_keys!
          
          self.orders_configuration = (self.orders_configuration || {}).dup
          
          orders.each do |column|
            self.orders_configuration[column] ||= { :default => false }
            self.orders_configuration[column] = self.orders_configuration[column].merge(options)
          end
        end
      end
      
      module InstanceMethods
      
        protected
          
          def current_ability
            @current_ability ||= ::Ability.new(current_user, :manage)
          end
          
          def search_filter
            @search_filter ||= Sunrise::Controllers::ModelFilter.new(self, params)
          end
      end
    end
  end
end
