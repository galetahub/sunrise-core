module Sunrise
  module Controllers
    module HeadOptions
      # Inclusion hook to make #current_user and #logged_in?
      # available as ActionView helper methods.
      def self.included(base)
        base.send :helper_method, :head_options if base.respond_to? :helper_method
      end
      
      def head_options(record, options = {})
        return if record.nil?
        
        options = { :spliter => " | " }.merge(options)
        
        header = record.respond_to?(:header) ? record.header : nil
        
        @view_title = record.title if record.respond_to?(:title)
        @view_title ||= I18n.t('page.title')
        
        # title
        page_title = []
		    page_title << options[:title] if options.key?(:title)
		    page_title << ((header.nil? || header.title.blank?) ? record.title : header.title)
		    page_title << I18n.t('page.title') if options[:append_title]
		    page_title.flatten!
		    page_title.compact!
		    page_title.uniq!
		
		    @page_title = page_title.join(options[:spliter])
		
		    # keywords
		    keywords = record.keywords.join(', ') if record.respond_to?(:keywords)
		    keywords ||= (header.nil? || header.keywords.blank?) ? page_title.join(' ').split.join(', ') : header.keywords
		    @page_keywords = keywords
		
		    # description
		    description = (header.nil? || header.description.blank?) ? page_title.join(" - ") : header.description
		    @page_description = description
      end
    end
  end
end
