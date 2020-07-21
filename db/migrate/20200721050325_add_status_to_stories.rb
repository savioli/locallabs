class AddStatusToStories < ActiveRecord::Migration[6.0]
  def change

    add_column :stories, :status, :integer, default: nil

  end
end
