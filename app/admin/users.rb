ActiveAdmin.register User do
  scope :admins
  scope :active
  scope :blocked
  scope :with_enabled_newsletter
  scope :with_disabled_newsletter

  controller do
    def scoped_collection
      super.includes :authentications
    end
  end

  index do
    column :id
    column :email
    column :preferred_language
    column :enabled_newsletter
    column :admin
    column :provider_names do |user|
      user.provider_names.join(', ')
    end
    column :blocked
    column :blocked_at
    column :sign_in_count
    column :current_sign_in_at
    column :last_sign_in_at
    column :current_sign_in_ip
    column :last_sign_in_ip
    column :failed_attempts
    column :created_at
    column :updated_at

    actions
  end

  form do |f|
    f.inputs 'Edit user' do
      f.input :email
      f.input :admin
      f.input :blocked
    end
    f.actions
  end
end
