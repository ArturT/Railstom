class AuthenticationService
  takes :authentication_repository, :current_user, :omniauth_hash

  def find_or_build
    authentication_repository.find_by_provider_and_uid(omniauth_hash['provider'], omniauth_hash['uid']) || build_with_omniauth
  end

  def build_with_omniauth
    authentication_repository.build({
      provider: omniauth_hash['provider'],
      uid: omniauth_hash['uid'].to_s
    })
  end

  def user_linked?(authentication, user = current_user)
    authentication.user == user
  end

  def user_link_with(authentication, user = current_user)
    authentication.update_attribute(:user, user)
  end

  def has_user?(authentication)
    !authentication.user.blank?
  end
end
