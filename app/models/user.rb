class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable, :async, :lockable

  mount_uploader :avatar, AvatarUploader

  has_many :authentications, dependent: :destroy

  before_update :update_password_changed

  scope :admins, -> { where(admin: true) }
  scope :active, -> { where(blocked: false) }
  scope :blocked, -> { where(blocked: true) }

  validates :preferred_language, presence: true
  validate :valid_preferred_language

  def self.build_with_omniauth(auth)
    user = self.new

    if auth['info']
      user.email = auth['info']['email']
      user.remote_avatar_url = auth['info']['image']
    end
    user.generate_password
    user.confirm
    user.password_changed = false
    user.preferred_language = I18n.locale

    user
  end

  def confirm
    self.confirmation_token = nil
    self.confirmed_at = Time.now.utc
  end

  def generate_password
    self.password = SecureRandom.urlsafe_base64[0..7]
  end

  def has_provider?(provider)
    self.authentications.where(provider: provider).present?
  end

  def provider_names
    # if user changed his password it's mean that he can also use email to sign in
    providers = password_changed? ? ['email'] : []

    authentications.each do |authentication|
      providers << authentication.provider
    end

    providers
  end

  private

  def valid_preferred_language
    unless Locale.supported_language?(self.preferred_language)
      errors.add(:preferred_language, I18n.t('activemodel.errors.messages.not_supported_preferred_language'))
    end
  end

  def update_password_changed
    if self.encrypted_password_changed? && self.password_changed == false
      self.password_changed = true
    end
  end
end
