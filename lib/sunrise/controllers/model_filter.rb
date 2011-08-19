# encoding: utf-8
require 'ostruct'

module Sunrise
  module Controllers
    class ModelFilter
      attr_accessor :controller, :params, :order
      
      def initialize(controller, params = {})
        @params = params.symbolize_keys
        @controller = controller
        @order = extract_order(@params[:search] || {})
      end
      
      def method_missing(method, *args, &block)
        match_data = method.to_s.match(/^(.+)_before_type_cast$/)
        method_name = (match_data ? match_data[1] : method).to_sym
        
        if respond_to?(method_name)
          @params[method_name]
        else
          super
        end
      end
      
      def respond_to?(method_name)
        return true if scope?(method_name) || @params.has_key?(method_name.to_sym)
        super
      end
      
      def scope?(method_name)
        controller.scopes_configuration.values.collect { |v| v[:as] }.include?(method_name.to_sym)
      end
      
      def order?(method_name)
        controller.orders_configuration.keys.include?(method_name.to_sym)
      end
      
      def to_key
        []
      end
      
      def current_order
        "#{@order_column}_#{@order_type}"
      end
      
      class << self
        def model_name
          @_model_name ||= OpenStruct.new(:singular => "search", :plural => "searches")
        end
      end
      
      private
        
        def extract_order(options = {})
          options = options.symbolize_keys
          
          ocolumn = options.delete(:order_column)
          otype = options.delete(:order_type)
          
          unless ocolumn.blank?
            @order_column = ocolumn.to_s.strip.downcase.to_s
            @order_column = nil unless order?(@order_column)
          end

          unless @order_column.blank?
            @order_type = otype.to_s.strip.downcase unless otype.blank?
            @order_type = nil unless ['desc', 'asc'].include?(@order_type)
            @order_type ||= 'desc'
            
            "#{@order_column} #{@order_type}"
          end
        end
    end
  end
end
