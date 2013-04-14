# DOERS [User] class
class User < ActiveRecord::Base
  # Include support for authentication
  include EasyAuth::Models::Account

  # Relationships
  has_many :projects, :dependent => :destroy
  has_many :panels
  has_many :boards

  # Validations
  validates :email, :uniqueness => true, :presence => true
end
