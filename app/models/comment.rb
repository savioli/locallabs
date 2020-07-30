class Comment < ApplicationRecord
    belongs_to :story
    belongs_to :commentator, class_name: 'User', foreign_key: 'commentator_id', optional: false
end
