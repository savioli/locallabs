class AddStoryToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :story_id, :integer
  end
end
