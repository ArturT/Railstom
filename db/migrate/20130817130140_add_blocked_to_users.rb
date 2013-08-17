class AddBlockedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :blocked, :boolean, null: false, default: false

    add_index :users, :blocked
  end
end
