class StructureType < Sunrise::Models::StructureType
  include EnumField::DefineEnum
  
  define_enum do |builder|
    builder.member :page,     :object => new("page")
    builder.member :posts,    :object => new("posts")
    builder.member :main,     :object => new("main")
    builder.member :redirect, :object => new("redirect")
    builder.member :group,    :object => new("group")
  end
end
