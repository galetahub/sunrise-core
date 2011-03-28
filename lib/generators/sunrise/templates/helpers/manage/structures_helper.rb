module Manage::StructuresHelper

  def edit_structure_record_path(structure)                   
    case structure.structure_type
      when StructureType.page then edit_manage_structure_page_path(:structure_id=>structure.id)      
      when StructureType.posts then manage_structure_posts_path(:structure_id => structure.id)
      when StructureType.main then '#'
      when StructureType.redirect then structure.slug
      when StructureType.group then '#'
    end
  end
end
