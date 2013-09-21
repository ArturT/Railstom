class UserRepository
  takes :db_user, :omniauth_hash

  def build(attrs = {})
    db_user.new(attrs)
  end

  def find_with_omniauth
    db_user.find_by(email: omniauth_hash['info'].try(:[], 'email'))
  end
end
