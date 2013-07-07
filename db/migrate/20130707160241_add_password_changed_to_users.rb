class AddPasswordChangedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_changed, :boolean, null: false, default: true
  end
end
