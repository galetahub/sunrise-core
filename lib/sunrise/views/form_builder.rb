require 'simple_form'

module Sunrise
  module Views
    class FormBuilder < ::SimpleForm::FormBuilder
      delegate :concat, :content_tag, :link_to, :link_to_function, :to => :template
      
      def input(attribute_name, options = {}, &block)
        options[:input_html] ||= {}
        options[:input_html] = { :class => 'text' }.merge(options[:input_html])
        
        super(attribute_name, options, &block)
      end
      
      def button(type, *args, &block)
        options = args.extract_options!
        url = options[:url] || polymorphic_path([:manage, object_plural])
        
        content_tag(:div, :style => "padding: 20px 0px 10px 20px;", :class => "buts") do
          concat link_to_function content_tag(:span, t('manage.create')), "$(this).parents('form').submit()", :class=>"gr"
          concat link_to t('manage.cancel'), url, :class=>"erase"
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
