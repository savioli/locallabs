class Organization < ApplicationRecord

    has_many :users
    has_many :writers
    has_many :chief_editors

end
