namespace :fix do
  namespace :facebook do
    task password_changed: :environment do
      User.joins(:authentications).merge(Authentication.where(provider: 'facebook')).update_all(password_changed: false)
    end
  end
end
