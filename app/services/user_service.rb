class UserService
  takes :user_repository, :omniauth_hash, :generator_service

  def build_with_omniauth
    attrs = {
      password: generator_service.password(8),
      confirmation_token: nil,
      confirmed_at: Time.now.utc
    }

    if omniauth_hash['info']
      attrs[:email] = omniauth_hash['info']['email']
      attrs[:remote_avatar_url] = omniauth_hash['info']['image']
    end

    user_repository.build(attrs)
  end
end
