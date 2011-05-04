require 'simple_form'
require 'sunrise/views/inputs/date_time_input'

module Sunrise
  module Views
    class FormBuilder < ::SimpleForm::FormBuilder
      delegate :concat, :content_tag, :link_to, :link_to_function, :to => :template
      
      def input(attribute_name, options = {}, &block)
        options[:input_html] ||= {}
        options[:input_html] = { :class => 'text' }.merge(options[:input_html])
        
        attribute_name = "#{attribute_name}_#{options[:locale]}" unless options[:locale].blank?
        
        super(attribute_name, options, &block)
      end
      
      def globalize(options={}, &block)
        locales = options[:locales] || Sunrise.available_locales
        html = []
        
        html.join.html_safe
      end
      
      def button(type, *args, &block)
        options = args.extract_options!
        url = options[:url] || [:manage, object_plural]
        
        content_tag(:div, :style => "padding: 20px 0px 10px 20px;", :class => "buts") do
          concat link_to_function content_tag(:span, I18n.t('manage.create')), "$(this).parents('form').submit()", :class=>"gr"
          concat link_to I18n.t('manage.cancel'), url, :class=>"erase"
          concat super(type, {:style => "display:none"}, &block)
        end
      end
      
      protected
      
        def object_plural
          object_name.to_s.pluralize
        end
    end
  end
end
