class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.boolean :enabled_force, null: false, default: false
      t.boolean :stopped, null: false, default: false
      t.integer :last_user_id, null: false, default: 0
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
