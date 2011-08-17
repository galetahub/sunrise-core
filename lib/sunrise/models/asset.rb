# encoding: utf-8
require 'mime/types'

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
    
            #before_validation :make_content_type
            before_create :read_dimensions
            
            delegate :url, :original_filename, :content_type, :size, :path, :styles, :to => :data
            alias :filename :original_filename
          end
        end
        
        def move_to(index, id)
          update_all(["sort_order = ?", index], ["id = ?", id.to_i])
        end
      end
      
      module InstanceMethods
        
        def thumb_url
          url(:thumb)
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
        
        def as_json(options = nil)
          options = {
            :only => [:id, :guid, :assetable_id, :assetable_type, :user_id], 
            :root => 'asset', 
            :methods => [:filename, :url, :size, :content_type, :thumb_url]
          }.merge(options || {})
          
          super
        end
        
        def has_dimensions?
          respond_to?(:width) && respond_to?(:height)
        end
        
        def image?
          Sunrise::Utils::IMAGE_TYPES.include?(self.data_content_type)
        end
        
      end
    end
  end
end
