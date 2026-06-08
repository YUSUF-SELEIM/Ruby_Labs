class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :articles, dependent: :destroy   
  validates :email_address, presence: true, uniqueness: true
end