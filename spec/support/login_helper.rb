module LoginHelper
  def login_as(user, locale=:en)
    visit new_user_session_path(locale)
    fill_in 'user_email', :with => user.email
    fill_in 'user_password', :with => user.password
    find(:xpath, '//input[@name="commit"]').click
  end
end
