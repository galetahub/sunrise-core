class AttachmentFileUploader < Sunrise::CarrierWave::BaseUploader  
  def extension_white_list
    %w(pdf doc docx xls xlsx ppt pptx zip rar csv)
  end
end
