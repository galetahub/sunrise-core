Factory.define :structure_page, :class => Structure do |s|
  s.title 'Structure'
  s.slug { Factory.next(:slug) }
  s.structure_type StructureType.page
  s.position_type PositionType.menu
  s.is_visible true
end

Factory.define :structure_main, :class => Structure do |s|
  s.title "Main page"
  s.slug "main-page"
  s.structure_type StructureType.main
  s.position_type PositionType.default
  s.is_visible true
end

Factory.sequence :slug do |n|
  "slug#{n}"
end
