ActiveAdmin.register Newsletter do
  index do
    column :id
    column :subject
    column :enabled_force
    column :stopped
    column :sent_email_count
    column :started_at
    column :finished_at
    column :created_at
    column :updated_at

    default_actions
  end

  form do |f|
    f.inputs do
      f.input :subject
      f.input :body
      f.input :enabled_force
      f.input :stopped
      f.input :started_at if f.object.new_record?
    end
    f.actions
  end
end
