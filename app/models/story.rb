class Story < ApplicationRecord

  belongs_to :writer, class_name: 'Writer', foreign_key: 'writer_id', optional: true
  belongs_to :reviewer, class_name: 'Writer', foreign_key: 'reviewer_id', optional: true

  enum status: [ :unassigned,
                 :draft,
                 :for_review,
                 :in_review,
                 :pending,
                 :approved,
                 :published,
                 :archived ]

end
