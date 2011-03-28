module Manage::UsersHelper
  def manage_user_avatar_tag(record, options={})
	  options.symbolize_keys!
		
		type = options.has_key?(:type) ? options.delete(:type).to_sym : nil
		image_type = type.blank? ? "manage/user_pic.gif" : "manage/user_pic_#{type}.gif"
		
		path = (record.nil? || record.avatar.nil?) ? image_type : record.avatar.url(type)
				
		image_title = options.delete(:title)
		image_title ||= record.name unless record.nil?
		options[:title] = options[:alt] = image_title
		
		image_tag path, options
	end
end
