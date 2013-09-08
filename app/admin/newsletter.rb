ActiveAdmin.register Newsletter do
  index do
    last_user = User.select('id').last
    users_count = { all: User.count }
    newsletter_members_count = { all: User.where(enabled_newsletter: true).count }
    Locale.supported_languages.each do |locale|
      users_count[locale] = User.where(preferred_language: locale).count
      newsletter_members_count[locale] = User.where(preferred_language: locale, enabled_newsletter: true).count
    end

    column :id
    column :language do |o|
      if o.language.blank?
        'all'
      else
        o.language
      end
    end
    column :subject
    column :enabled_force
    column :stopped
    column :sent_email_count do |o|
      if o.enabled_force
        if o.language.blank?
          "#{o.sent_email_count}/#{users_count[:all]}"
        else
          "#{o.sent_email_count}/#{users_count[o.language]}"
        end
      else
        if o.language.blank?
          "#{o.sent_email_count}/#{newsletter_members_count[:all]}"
        else
          "#{o.sent_email_count}/#{newsletter_members_count[o.language]}"
        end
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
      f.input :language, collection: Locale.collection_of_languages, hint: t('active_admin.newsletters.hints.language')
      f.input :subject
      f.input :body
      f.input :enabled_force, hint: t('active_admin.newsletters.hints.enabled_force')
      f.input :stopped, hint: t('active_admin.newsletters.hints.stopped')
      f.input :started_at, hint: t('active_admin.newsletters.hints.started_at') if f.object.new_record?
      f.input :preview_email, hint: t('active_admin.newsletters.hints.preview_email')
    end
    f.actions
  end
end
