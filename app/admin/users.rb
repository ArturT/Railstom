ActiveAdmin.register User do
  scope :admins

  index do
    column :id
    column :email
    column :admin
    column :provider_names do |user|
      user.provider_names.join(', ')
    end
    column :current_sign_in_at
    column :last_sign_in_at
    column :current_sign_in_ip
    column :last_sign_in_ip
    column :failed_attempts
    column :created_at
    column :updated_at

    default_actions
  end

  form do |f|
    f.inputs 'Edit user' do
      f.input :email
      f.input :admin
    end
    f.buttons
  end
end
