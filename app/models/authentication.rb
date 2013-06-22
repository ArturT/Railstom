class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id

  belongs_to :user

  validates :provider, :uid, presence: true

  def self.find_with_omniauth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid'].to_s)
  end

  def self.new_with_omniauth(auth)
    new(provider: auth['provider'], uid: auth['uid'].to_s)
  end
end
