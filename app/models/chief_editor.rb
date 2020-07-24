class ChiefEditor < User
  belongs_to :organization
  # has_many :stories
  has_secure_password
end
