class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :text
      t.integer :location_id
      t.integer :user_id

      t.timestamps
    end
  end
end
