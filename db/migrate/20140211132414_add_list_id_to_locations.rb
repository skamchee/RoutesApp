class AddListIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :list_id, :integer
  end
end
