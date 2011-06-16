# == Schema Information
#
# Table name: users
#
#  id                   :integer(4)      not null, primary key
#  name                 :string(150)
#  login                :string(20)      not null
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer(4)      default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  confirmation_token   :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  failed_attempts      :integer(4)      default(0)
#  locked_at            :datetime
#  created_at           :datetime
#  updated_at           :datetime
#
# Indexes
#
#  index_users_on_login                 (login) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#

class User < ActiveRecord::Base
  include Sunrise::Models::User
  
  # Include default devise modules.
  devise :database_authenticatable, :confirmable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable,
         :encryptable, :encryptor => :sha512

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  fileuploads :avatar
end
