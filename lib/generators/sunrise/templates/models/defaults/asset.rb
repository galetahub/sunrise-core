class Asset < ActiveRecord::Base
  include Sunrise::Models::Asset
  
  attr_accessible :data
  
  validates_presence_of :data
	
	default_scope order("#{quoted_table_name}.sort_order")
end 
