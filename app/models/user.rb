class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :authentications, dependent: :destroy

  before_update :update_password_changed

  def self.build_with_omniauth(auth)
    user = self.new

    user.email = auth['info']['email'] if auth['info']
    user.generate_password
    user.confirm
    user.password_changed = false

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
    self.authentications.find_by_provider(provider).present?
  end

  private

  def update_password_changed
    if self.encrypted_password_changed? && self.password_changed == false
      self.password_changed = true
    end
  end
end
