class AddPreferredLanguageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :preferred_language, :string, null: false, default: ''
  end
end
