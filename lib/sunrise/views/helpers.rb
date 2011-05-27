module Sunrise
  module Views
    module Helpers
      
      def title(content)
	      content_for(:title) { content } unless content.blank?
      end

      def javascript(*args)
	      content_for(:head) { javascript_include_tag(*args) }
      end

      def stylesheet(*args)
        content_for(:head) { stylesheet_link_tag(*args) }
      end

      def description(content)
        content_for(:description) { tag(:meta, :content=>content, :name=>"description") } unless content.blank?
      end

      def keywords(content)
        content_for(:keywords) { tag(:meta, :content=>content, :name=>"keywords") } unless content.blank?
      end
      
      def render_title
        @page_title || I18n.t("page.title")
      end
      
      def render_keywords
        @page_keywords || I18n.t("page.keywords")
      end
      
      def render_description
        @page_description || I18n.t("page.description")
      end

      def anchor_to(name, options={})
        return if name.blank?
        options[:name] = name
        
        content_tag(:a, '', options)
      end

      def link_by_href(name, options={})
        link_to name, name, options
      end

      def link_to_unless_current_span(name, options = {}, html_options = {}, &block)
        link_to_unless_span current_page?(options), name, options, html_options, &block
      end

      def link_to_unless_span(condition, name, options = {}, html_options = {}, &block)
        if condition
          if block_given?
	          block.arity <= 1 ? yield(name) : yield(name, options, html_options)
          else
           content_tag(:span, name, html_options)
          end
        else
          link_to(name, options, html_options)
        end
      end

      def link_to_unless_current_tag(name, options = {}, html_options = {}, &block)
        link_to_unless_tag current_page?(options), name, options, html_options, &block
      end

      def link_to_if_tag(condition, name, options = {}, html_options = {}, &block)
        tag_name = html_options.delete(:tag) || :span
        if condition
          link_to(name, options, html_options)
        else
          if block_given?
	          block.arity <= 1 ? yield(name) : yield(name, options, html_options)
          else
           content_tag(tag_name, name, html_options)
          end
        end
      end	

      def link_to_unless_tag(condition, name, options = {}, html_options = {}, &block)
        tag_name = html_options.delete(:tag) || :span
        unless condition
          link_to(name, options, html_options)
        else
          if block_given?
	          block.arity <= 1 ? yield(name) : yield(name, options, html_options)
          else
           content_tag(tag_name, name, html_options)
          end
        end
      end	

      def link_to_remote_if(condition, name, options = {}, html_options = nil)
        return name unless condition
        link_to_function(name, remote_function(options), html_options || options.delete(:html))
      end

      def submit_image(name, src, options={})
        html_options = options.dup.symbolize_keys
        
        html_options[:name] = name
        html_options[:src] = src
        html_options[:type] ||= 'image'
        
        tag(:input, html_options)
      end

      def submit_image_to_remote(name, value, options = {})
        options[:with] ||= 'Form.serialize(this.form)'
        
        html_options = options.delete(:html) || {}
        html_options[:name] = name
        html_options[:type] ||= 'button'

        onclick = html_options.delete(:onclick) || remote_function(options)

        tag(:input, html_options.merge(:value => name, :onclick => onclick))
      end

      def locale_image_tag(source, options = {})
        source = "#{I18n.locale}/#{source}"
        image_tag(source, options)
      end

      # swf_object
      def swf_object(swf, id, width, height, flash_version, options = {})
        options.symbolize_keys!
        
        params = options.delete(:params) || {}
        attributes = options.delete(:attributes) || {}
        flashvars = options.delete(:flashvars) || {}
        
        attributes[:classid] ||= "clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
        attributes[:id] ||= id
        attributes[:name] ||= id
        
        output_buffer = ActiveSupport::SafeBuffer.new
        
        if options[:create_div]
          output_buffer << content_tag(:div, 
            "This website requires <a href='http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash&promoid=BIOW' target='_blank'>Flash player</a> #{flash_version} or higher.",
            :id => id)
        end
        
        js = []
        
        js << "var params = {#{params.to_a.map{|item| "#{item[0]}:'#{item[1]}'" }.join(',')}};"
        js << "var attributes = {#{attributes.to_a.map{|item| "#{item[0]}:'#{item[1]}'" }.join(',')}};"
        js << "var flashvars = {#{flashvars.to_a.map{|item| "#{item[0]}:'#{item[1]}'" }.join(',')}};"

        js << "swfobject.embedSWF('#{swf}', '#{id}', '#{width}', '#{height}', '#{flash_version}', '/swf/expressInstall.swf', flashvars, params, attributes);"

        output_buffer << javascript_tag(js.join)
        
        output_buffer
      end

      def encode_email(email_address, options = {})
        email_address = email_address.to_s
        string = ''

        "document.write('#{email_address}');".each_byte do |c|
           string << sprintf("%%%x", c)
         end
         
        "<script type=\"#{Mime::JS}\">eval(decodeURIComponent('#{string}'))</script>"
      end
      
      def record_asset_tag(record, method_name, default_image, options = {})
        asset = record ? record.send(method_name) : nil
        asset_type = options.has_key?(:type) ? options.delete(:type).to_sym : nil
        extname = File.extname(default_image)
		    image_path = asset_type.nil? ? default_image : "#{File.basename(default_image, extname)}_#{asset_type}#{extname}"
		    image_full = default_image.gsub(File.basename(default_image), image_path)
		
		    path = (asset && (asset.respond_to?(:persisted?) ? asset.persisted? : true)) ? asset.url(asset_type) : image_full
	      
		    image_tag(path, options)
      end
      
      def manage_form_for(object, *args, &block)
        options = args.extract_options!
        options[:builder] ||= Sunrise::Views::FormBuilder
        
        simple_form_for([:manage, object].flatten, *(args << options), &block)
      end
    end
  end
end
