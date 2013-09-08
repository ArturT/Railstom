class AddEnabledNewsletterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :enabled_newsletter, :boolean, null: false, default: true
  end
end
