def insert_user  
  User.truncate_table
  Role.truncate_table
  password = Devise.friendly_token
  
  admin = User.new(:name=>'Administrator', :email=>'dev@aimbulance.com',
                   :password=>password, :password_confirmation=>password)
  admin.login = 'admin' if admin.respond_to?(:login)
  admin.roles.build(:role_type => RoleType.admin)
  admin.skip_confirmation!
  admin.save!

  puts "Admin: #{admin.email}, #{admin.password}"
end

def insert_structures
  Structure.truncate_table
  
  main_page = Structure.create!(:title => "Главная страница", :slug => "main-page", :structure_type => StructureType.main, :parent => nil)
  #Structure.create!(:title => "Трансляции", :slug => "broadcasts", :structure_type => StructureType.broadcasts, :parent => main_page)
  #Structure.create!(:title => "Прямые репортажи", :slug => "posts", :structure_type => StructureType.posts, :parent => main_page)
end

insert_user
insert_structures
