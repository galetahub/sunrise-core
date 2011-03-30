# encoding: utf-8
module Sunrise
  class ModelFilter
    attr_accessor :klass
    
    attr_accessor :attributes, :columns
    
    attr_accessor :order_by, :order_column, :order_type
    
    attr_accessor :conditions
    
    def initialize(klass, options={})
      options.symbolize_keys!
      
      @klass = klass
      
      @columns = options[:columns]
      @columns ||= klass.respond_to?(:column_names) ? @klass.column_names : []
      
      @attributes = options[:attributes] || {}
      @raw_values = {}
    end
    
    def filter(options = {})
      order = options.delete(:order)
      where = options.delete(:conditions)
      
      {
        :order => (self.order_by || order || "id DESC"),
        :conditions => (self.conditions || where)
      }.merge(options)
    end
    
    def scoped
      query = @klass.scoped
      query = query.order(order_by) unless order_by.blank?
      query = query.where(conditions) if conditions && !conditions.empty? 
      query
    end
    
    def next_order_type
      return if @order_type.blank?
      
      @order_type == 'desc' ? 'asc' : 'desc'
    end
    
    def update_attributes(params = {})
      return if params.nil? || params.keys.empty?
      
      options = params.symbolize_keys
      
      @raw_values = extract_values(options)
      @conditions = extract_conditions(options)
      @order_by = extract_order(options)
    end
    
    def method_missing(method, *args, &block)
      match_data = method.to_s.match(/^(.+)_before_type_cast$/)
      method_name = (match_data ? match_data[1] : method).to_sym
      
      if @attributes.include?(method_name)
        @raw_values[method_name]
      else
        super
      end
    end
    
    def respond_to?(method_name)
      return true if @attributes.include?(method_name.to_sym)
      super
    end
    
    private
      
      def normalize_value(attribute, value)
        column = @klass.columns_hash[attribute.to_s]
        
        case column.type
          when :string then value.to_s
          when :integer then value.to_s.blank? ? nil : value.to_i
          when :float then value.to_s.blank? ? nil : value.to_f
          else value
        end
      end
      
      def extract_order(options={})
        options.symbolize_keys!
        
        ocolumn = options.delete(:order_column)
        otype = options.delete(:order_type)
        
        unless ocolumn.blank?
          @order_column = ocolumn.to_s.strip.downcase.to_s
          @order_column = nil unless @columns.include?(@order_column)
        end

        unless @order_column.blank?
          @order_type = otype.to_s.strip.downcase unless otype.blank?
          @order_type = nil unless ['desc', 'asc'].include?(@order_type)
          @order_type ||= 'desc'
          
          real_column = @order_column.to_s
          
          if @klass.respond_to?(:translated_columns) && @klass.translated_columns.include?(real_column)
            locale = (I18n.locale.to_s == 'uk' ? 'ua' : 'ru')
            real_column = "#{@order_column}_#{locale}"
          end
          
          "#{@klass.quoted_table_name}.#{real_column} #{@order_type}"
        end
      end
      
      def extract_values(options={})
        values = {}
        
        options.each do |k, v|
          key = k.to_sym
          values[key] = normalize_value(k, v) if @attributes.include?(key)
        end
        
        values
      end
      
      def extract_conditions(options={})
        c_names = []
        c_values = []
        
        @raw_values.each do |k, v|
          next if v.blank?
          
          arr = extract_method(k, v)
          
          c_names << arr.first
          c_values << arr.last
        end
        
        [c_names.join(' AND ')] + c_values
      end
      
      def extract_method(attribute, value)
        column = @klass.columns_hash[attribute.to_s]
        
        case column.type
          when :string, :text then
            x = "#{@klass.quoted_table_name}.#{attribute} LIKE ?"
            y = value.nil? ? nil : "#{value}%"
          when :boolean then
            x = "#{@klass.quoted_table_name}.#{attribute} = ?"
            y = (value && value.to_i == 1) ? 1 : 0
          when :integer, :float then
            x = "#{@klass.quoted_table_name}.#{attribute} = ?"
            y = value.nil? ? nil : value.to_i
        end
        
        [x, y]
      end
  end
end
