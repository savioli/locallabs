class ChiefEditor < User
  belongs_to :organization
  has_secure_password
end