module Manage::UsersHelper
  def manage_user_avatar_tag(record, options={})
	  options.symbolize_keys!
	  record_asset_tag(record, :avatar, "manage/user_pic.gif", options.merge(:title => record.try(:name)))
	end
end
