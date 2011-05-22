require 'simple_form'
require 'sunrise/views/inputs/date_time_input'

module Sunrise
  module Views
    class FormBuilder < ::SimpleForm::FormBuilder
      delegate :concat, :content_tag, :link_to, :link_to_function, :dom_id, :to => :template
      
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
        
        html = options[:input_html] || {}
        url = options[:url] || [:manage, object_plural]
        value = object.new_record? ? 'create' : 'update'
        title = html[:title] || I18n.t(value, :scope => :manage)
        
        html = {
          :value => value, :type => type, 
          :class => "gr cupid-green", :name => "commit"
        }.merge(html)
        
        content_tag(:div, :class => "buts controls") do
          concat content_tag(:button, title, html)
          concat link_to(I18n.t('manage.cancel'), url, :class => "erase")
        end
      end
      
      def attach_file_field(attribute_name, options = {}, &block)
        value = options.delete(:value) if options.key?(:value)
        value ||= object.fileupload_asset(attribute_name)
               
        element_guid = object.fileupload_guid        
        element_id = dom_id(object, [attribute_name, element_guid].join('_'))
        script_options = (options.delete(:script) || {}).stringify_keys
        
        params = {
          :klass => object.class.reflect_on_association(attribute_name).class_name, 
          :assetable_id => object.new_record? ? nil : object.id, 
          :assetable_type => object.class.name,
          :guid => element_guid
        }.merge(script_options.delete(:params) || {})
        
        script_options['action'] ||= '/sunrise/fileupload?' + Rack::Utils.build_query(params)
        script_options['allowedExtensions'] ||=  ['jpg', 'jpeg', 'png', 'gif']
        script_options['multiple'] ||= object.fileupload_multiple?(attribute_name)
        script_options['element'] ||= element_id
        
        label ||= if object && object.class.respond_to?(:human_attribute_name)
          object.class.human_attribute_name(attribute_name)
        end
        
        locals = {
          :element_id => element_id,
          :file_title => (options[:file_title] || "JPEG, GIF, PNG or TIFF"),
          :file_max_size => (options[:file_max_size] || 10),
          :label => (label || attribute_name.to_s.humanize),
          :object => object,
          :attribute_name => attribute_name,
          :assets => (value.new_record? ? [] : [value].flatten),
          :script_options => script_options.inspect.gsub('=>', ':'),
          :multiple => script_options['multiple'],
          :asset_klass => params[:klass]
        }
        
        template.render(:partial => "manage/fileupload/container", :locals => locals)
      end
      
      protected
      
        def object_plural
          object_name.to_s.pluralize
        end
    end
  end
end
