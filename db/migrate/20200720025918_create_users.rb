class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :type
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
