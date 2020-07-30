class AddCreatorToStories < ActiveRecord::Migration[6.0]
  def change

    # Notice how the index is for :creator but references users
    add_reference :stories, :creator, references: :users, index: true, null: true
    
    # Just like the belongs_to contained class_name: :User, the foreign key
    # also needs a specific custom column name as :creator_id
    add_foreign_key :stories, :users, column: :creator_id
    
  end
end
