class User < ActiveRecord::Base
  has_many :books
  validates :email, :username, presence: true
  has_secure_password
end