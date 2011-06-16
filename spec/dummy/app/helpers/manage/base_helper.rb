module Manage::BaseHelper
  def content_manager?
    user_signed_in? && current_user.admin?
  end
        
  def link_to_unless_current_span2(name, options = {}, html_options = {}, &block)
    if current_page?(options)
			if block_given?
				block.arity <= 1 ? yield(name) : yield(name, options, html_options)
			else
			 content_tag(:span, content_tag(:span, name), html_options)
			end
		else
			link_to(name, options, html_options)
		end
	end
	
	def options_for_ckeditor(options = {})
	  {:width=>700, :height=>400, 
	   :swf_params=>{:assetable_type=>current_user.class.name, :assetable_id=>current_user.id}
	     
	  }.update(options)
	end
	
	def white_block_form(options = {}, &block)
	  title = options[:title]
	  
	  concat(content_tag(:div, {:class=>"edit-white-bl"}) do
	    concat(content_tag(:div, {:class=>"bot-bg"}) do
	      concat(content_tag(:div, title, :class=>"wh-title")) unless title.blank?
	      yield if block_given?
	    end)
	  end)
	end
	
	def link_to_sort(title, options = {})
    options.symbolize_keys!
    
    order_type = options[:order_type] || 'asc'
    order_column = options[:name] || 'id'
    class_name = options[:class] || nil
                    
    search_options = request.params[:search] || {}
    search_options.update(:order_column => order_column, :order_type => order_type)
    
    link_to(title, :search => search_options, :class => class_name)
  end
  
  def remove_child_link(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def add_child_link(name, f, method, options={})
    options.symbolize_keys!
    
    html_options = options.delete(:html) || {}
    fields = new_child_fields(f, method, options)
    
    html_options[:class] ||= "new"
    
    content_tag(:div, 
      link_to_function(name, h("insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\")"), html_options),
      :class=>"add-bl")
  end
  
  def new_child_fields(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :form
    
    form_builder.fields_for(method, options[:object], :child_index => "new_#{method}") do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
    end
  end
  
  def cookie_content_tag(tag_name, options={}, &block)
    key = options[:id]
    options[:style] = "display:none;" if !cookies[key].blank? && cookies[key].to_i != 1
    content_tag(tag_name, options, &block)
  end
end
