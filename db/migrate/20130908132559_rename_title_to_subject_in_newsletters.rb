class RenameTitleToSubjectInNewsletters < ActiveRecord::Migration
  change_table :newsletters do |t|
    t.rename :title, :subject
  end
end
