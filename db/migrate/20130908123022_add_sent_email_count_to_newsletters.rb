class AddSentEmailCountToNewsletters < ActiveRecord::Migration
  def change
    add_column :newsletters, :sent_email_count, :integer, null: false, default: 0
  end
end
