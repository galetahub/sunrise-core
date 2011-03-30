# encoding: utf-8
module Sunrise
  module Models
    module Asset
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend,  ClassMethods
      end
      
      module ClassMethods
        def self.extended(base)
          base.class_eval do
            belongs_to :user
            belongs_to :assetable, :polymorphic => true
    
            before_validation :make_content_type
            before_create :read_dimensions
          end
        end
        
        def move_to(index, id)
          update_all(["sort_order = ?", index], ["id = ?", id.to_i])
        end
      end
      
      module InstanceMethods
        def url(*args)
          data.url(*args)
        end
        
        def filename
          data_file_name
        end
        
        def content_type
          data_content_type
        end
        
        def size
          data_file_size
        end
        
        def path
          data.path
        end
        
        def styles
          data.styles
        end
        
        def format_created_at
          I18n.l(created_at, :format => "%d.%m.%Y %H:%M")
        end
        
        def to_xml(options = {}, &block)
          options = {:only => [:id], :root => 'asset'}.merge(options)
          
          options[:procs] ||= Proc.new do |options, record| 
            options[:builder].tag!('filename', filename)
            options[:builder].tag!('path', url)
            options[:builder].tag!('size', size)
            
            unless styles.empty?
              options[:builder].tag!('styles') do |xml|
                styles.each do |style|
                  xml.tag!(style.first, url(style.first))
                end
              end
            end
          end
          
          super
        end
        
        def has_dimensions?
          respond_to?(:width) && respond_to?(:height)
        end
        
        def image?
          Sunrise::Utils::IMAGE_TYPES.include?(data_content_type)
        end
        
        def geometry
          @geometry ||= Paperclip::Geometry.from_file(data.to_file)
          @geometry
        end
        
        protected
        
          def read_dimensions
            if image? && has_dimensions?
              self.width = geometry.width
              self.height = geometry.height
            end
          end
          
          def make_content_type
            if data_content_type.blank? || data_content_type == "application/octet-stream"
              content_types = MIME::Types.type_for(filename)
              self.data_content_type = content_types.first.to_s unless content_types.empty?
            end
          end
      end
    end
  end
end
