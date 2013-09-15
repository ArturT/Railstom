class AuthenticationRepository
  takes :db_authentication

  def build(attrs = {})
    db_authentication.new(attrs)
  end

  def find_by_provider_and_uid(provider, uid)
    db_authentication.find_by(provider: provider, uid: uid.to_s)
  end
end
