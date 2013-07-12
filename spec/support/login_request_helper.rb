module LoginRequestHelper
  def login_as(user, locale=:en)
    post_via_redirect user_session_path(locale), 'user[email]' => user.email, 'user[password]' => user.password
  end
end
