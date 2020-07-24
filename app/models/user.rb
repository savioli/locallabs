class User < ApplicationRecord
  belongs_to :organization
  # has_many :stories
  has_secure_password
end
