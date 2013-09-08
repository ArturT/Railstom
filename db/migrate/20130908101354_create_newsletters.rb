class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :title
      t.text :body
      t.boolean :enabled_force
      t.boolean :stopped
      t.integer :last_user_id
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
