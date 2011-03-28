ActionView::Base.field_error_proc = Proc.new do |html_tag, instance| 
  if html_tag =~ /<(input|textarea|select)/
    errors = instance.error_message.kind_of?(Array) ? instance.error_message : [instance.error_message]
    errors.collect! { |error| "<li>#{error}</li>" } 
    message = "<ul class='error_box error_box_narrow'>#{errors.join}</ul>".html_safe
    html_tag += message
  end
  
  if html_tag =~ /<label/
    html_tag
  else
    "<div class=\"field_with_errors\">#{html_tag}</div>".html_safe
  end
end
