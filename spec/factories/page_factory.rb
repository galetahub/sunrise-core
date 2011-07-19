Factory.define :page, :class => Page do |p|
  p.title "Test title"
  p.content "Test content"
  p.association :structure, :factory => :structure_page
end
