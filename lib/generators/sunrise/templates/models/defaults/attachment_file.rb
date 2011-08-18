# == Schema Information
#
# Table name: assets
#
#  id                :integer(4)      not null, primary key
#  data_file_name    :string(255)     not null
#  data_content_type :string(255)
#  data_file_size    :integer(4)
#  assetable_id      :integer(4)      not null
#  assetable_type    :string(25)      not null
#  type              :string(25)
#  guid              :string(10)
#  locale            :integer(1)      default(0)
#  user_id           :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#  duration          :float           default(0.0)
#  resolution_id     :integer(1)      default(0)
#
# Indexes
#
#  index_assets_on_assetable_type_and_type_and_assetable_id  (assetable_type,type,assetable_id)
#  index_assets_on_assetable_type_and_assetable_id           (assetable_type,assetable_id)
#  index_assets_on_user_id                                   (user_id)
#

class AttachmentFile < Asset
  sunrise_uploader AttachmentFileUploader
  
  validates_filesize_of :data, :maximum => 100.megabytes.to_i
end
