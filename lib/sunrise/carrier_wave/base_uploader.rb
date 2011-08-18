# encoding: utf-8
require 'mime/types'

module Sunrise
  module CarrierWave
    class BaseUploader < ::CarrierWave::Uploader::Base
      include ::CarrierWave::MiniMagick
            
      storage :file
      
      process :set_content_type
      process :set_size
      process :set_width_and_height
       
      # default store assets path 
      def store_dir
        "uploads/#{model.class.to_s.underscore}/#{model.id}"
      end
       
      # process :strip
      def strip
        manipulate! do |img|
          img.strip
          img = yield(img) if block_given?
          img
        end
      end
      
      # process :quality => 85
      def quality(percentage)
        manipulate! do |img|
          img.quality(percentage)
          img = yield(img) if block_given?
          img
        end
      end
      
      def default_url
        "/images/defaults/#{model.class.to_s.underscore}_#{version_name}.png"
      end
      
      def set_content_type
        type = file.content_type == 'application/octet-stream' || file.content_type.blank? ? MIME::Types.type_for(original_filename).first.to_s : file.content_type
         
        model.data_content_type = type
      end 
      
      def set_size
        model.data_file_size = file.size
      end
      
      def set_width_and_height
        if model.image? && model.has_dimensions?
          magick = ::Magick::Image.read(current_path).first
          model.width, model.height = magick.columns, magick.rows
        end
      end

      def image?
        model.image?
      end
    end
  end
end
