class Story < ApplicationRecord
  enum status: [ :unassigned,
                 :draft,
                 :for_review,
                 :in_review,
                 :pending,
                 :approved,
                 :published,
                 :archived ]

end
