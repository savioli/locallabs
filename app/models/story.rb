class Story < ApplicationRecord

  belongs_to :writer, class_name: 'Writer', foreign_key: 'writer_id', optional: true
  belongs_to :reviewer, class_name: 'Writer', foreign_key: 'reviewer_id', optional: true
  belongs_to :creator, class_name: 'ChiefEditor', foreign_key: 'creator_id', optional: false

  has_many :comments

  enum status: [ :unassigned,
                 :draft,
                 :for_review,
                 :in_review,
                 :pending,
                 :approved,
                 :published,
                 :archived ]

end
