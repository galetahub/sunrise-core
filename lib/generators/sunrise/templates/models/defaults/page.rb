class Page < ActiveRecord::Base
  include Sunrise::Models::Page
  
  attr_accessible :title, :content
end
