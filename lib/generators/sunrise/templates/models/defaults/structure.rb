class Structure < ActiveRecord::Base
  include Sunrise::Models::Structure
  
  acts_as_nested_set
  
  has_slug :prepend_id => false
  
  attr_accessible :title, :kind, :position, :parent_id, :redirect_url,
                  :position_type, :slug, :parent, :structure_type, 
                  :header_attributes, :is_visible
end
