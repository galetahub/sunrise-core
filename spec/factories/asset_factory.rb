Factory.define :asset_avatar, :class => Avatar do |a|
  include ActionDispatch::TestProcess
  
  a.data fixture_file_upload('files/rails.png', 'image/png')
  a.association :assetable, :factory => :default_user
end
