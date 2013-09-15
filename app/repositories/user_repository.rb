class UserRepository
  takes :db_user

  def build(attrs = {})
    db_user.new(attrs)
  end
end
