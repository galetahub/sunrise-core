module SimpleForm
  module Inputs
    class DateTimeInput < Base
      def input
        input_html_options[:value] ||= formated_value
        
        html = [@builder.text_field(attribute_name, input_html_options)]
        
        html << case input_type
          when :date then
            @builder.javascript_tag("$(function() {
		          $('##{@builder.object_name}_#{attribute_name}').datepicker({
			          numberOfMonths: 2,
			          showButtonPanel: true
		          });
	          });")
	        when :datetime then
	          @builder.javascript_tag("$(function() {
		          $('##{@builder.object_name}_#{attribute_name}').datetimepicker({
			          numberOfMonths: 2,
			          hourGrid: 4,
                minuteGrid: 10
		          });
	          });")
	      end

	      html.join.html_safe
      end

    private
      
      def formated_value
        object.send(attribute_name).try(:strftime, value_format)
      end
      
      def value_format
        case input_type
          when :date then "%d.%m.%Y"
          when :datetime then "%d.%m.%Y %H:%M"
          when :time then "%H:%M"
        end
      end
      
      def has_required?
        false
      end

      def label_target
        case input_type
        when :date, :datetime
          "#{attribute_name}_1i"
        when :time
          "#{attribute_name}_4i"
        end
      end
    end
  end
end

