# == Schema Information
#
# Table name: roles
#
#  id         :integer(4)      not null, primary key
#  role_type  :integer(1)      default(0)
#  user_id    :integer(4)      not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  fk_user  (user_id)
#

class Role < ActiveRecord::Base
  include Sunrise::Models::Role
  
  attr_accessible :role_type
end
