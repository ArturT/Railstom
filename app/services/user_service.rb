class UserService
  takes :user_repository, :omniauth_hash, :generator_service, :current_user

  def build_with_omniauth
    attrs = {
      password: generator_service.password(8),
      confirmation_token: nil,
      confirmed_at: Time.now.utc,
      password_changed: false,
      preferred_language: I18n.locale
    }

    if omniauth_hash['info']
      attrs[:email] = omniauth_hash['info']['email']
      attrs[:remote_avatar_url] = omniauth_hash['info']['image']
    end

    user_repository.build(attrs)
  end

  def cancel_account!(user = current_user)
    user.update_attributes({
      blocked: true,
      blocked_at: Time.now.utc
    })
  end
end
