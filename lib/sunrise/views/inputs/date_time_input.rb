module SimpleForm
  module Inputs
    class DateTimeInput < Base
      def input
        #@builder.send(:"#{input_type}_select", attribute_name, input_options, input_html_options)
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

