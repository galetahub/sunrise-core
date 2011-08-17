class AvatarUploader < Sunrise::CarrierWave::BaseUploader
  
  process :strip
  process :quality => 90
  
  version :thumb do
    process :resize_to_fill => [100, 100]
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
