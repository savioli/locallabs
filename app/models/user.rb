class User < ApplicationRecord

  belongs_to :organization
  has_secure_password

  def is_writer?
      return type == "Writer"
  end

  def is_chief_editor?
    return type =="ChiefEditor"
  end
end
