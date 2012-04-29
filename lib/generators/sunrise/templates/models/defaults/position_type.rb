class PositionType < Sunrise::Models::PositionType
  include EnumField::DefineEnum
  
  define_enum do |builder|
    builder.member :default,  :object => new("default")
    builder.member :menu,     :object => new("menu")
    builder.member :bottom,   :object => new("bottom")
  end
end
