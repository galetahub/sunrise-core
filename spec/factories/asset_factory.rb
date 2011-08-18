Factory.define :asset_avatar, :class => Avatar do |a|
  #include ActionDispatch::TestProcess
  a.data File.open('spec/factories/files/rails.png')
  a.association :assetable, :factory => :default_user
end

Factory.define :asset_avatar_big, :class => Avatar do |a|
  a.data File.open('spec/factories/files/silicon_valley.jpg')
  a.association :assetable, :factory => :default_user
end
