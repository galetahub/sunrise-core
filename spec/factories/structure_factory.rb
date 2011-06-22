Factory.define :structure, :class => Structure do |s|
  s.title 'Structure'
  s.slug { Factory.next(:slug) }
  s.structure_type StructureType.page
  s.position_type PositionType.menu
  s.is_visible true
end

Factory.sequence :slug do |n|
  "slug#{n}"
end
