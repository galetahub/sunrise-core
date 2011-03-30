class Header < ActiveRecord::Base
  include Sunrise::Models::Header
  
  attr_accessible :title, :keywords, :description
end
