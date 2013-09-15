class GeneratorService
  takes :omniauth_hash

  def password(length)
    SecureRandom.urlsafe_base64[0..length-1]
  end

  def nickname_with_omniauth
    auth = omniauth_hash['info']
    nickname = auth['nickname'] || auth['name']
    nickname.to_s.gsub(/\.|\s/,'')
  end
end
