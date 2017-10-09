class User < ActiveRecord::Base
  has_many :books
  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true 
  validates :email, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "format not valid" } 
  has_secure_password

  def read
    self.books.where(read: true)
  end

  def to_read
    self.books.where(read: nil)
  end
end