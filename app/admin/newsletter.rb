ActiveAdmin.register Newsletter do
  index do
    last_user = User.select('id').last
    users_count = User.count
    newsletter_members_count = User.where(enabled_newsletter: true).count

    column :id
    column :subject
    column :enabled_force
    column :stopped
    column :sent_email_count do |o|
      if o.enabled_force
        "#{o.sent_email_count}/#{users_count}"
      else
        "#{o.sent_email_count}/#{newsletter_members_count}"
      end
    end
    column :last_user_id do |o|
      "last user id: #{o.last_user_id}<br>max user id: #{last_user.id}".gsub(/\s/, '&nbsp;').html_safe
    end
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
      f.input :enabled_force, hint: t('active_admin.newsletters.hints.enabled_force')
      f.input :stopped, hint: t('active_admin.newsletters.hints.stopped')
      f.input :started_at, hint: t('active_admin.newsletters.hints.started_at') if f.object.new_record?
    end
    f.actions
  end
end
