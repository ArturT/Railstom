class Newsletter < ActiveRecord::Base
  validates :subject, :body, presence: true

  after_create :send_newsletter
  after_update :resume_newsletter

  attr_accessor :preview_email

  validate :send_preview_email

  private

  def send_newsletter
    if self.started_at.nil?
      NewsletterWorker.perform_async(self.id)
    else
      NewsletterWorker.perform_at(self.started_at, self.id)
    end
  end

  def resume_newsletter
    if self.stopped_changed? && self.stopped == false
      NewsletterWorker.perform_async(self.id)
    end
  end

  def send_preview_email
    unless self.preview_email.blank?
      user = User.new(email: self.preview_email, preferred_language: I18n.locale)
      NewsletterMailer.delay.newsletter(user, self.subject, self.body)
      errors.add(:preview_email, I18n.t('activemodel.errors.messages.preview_email', email: user.email))
    end
  end
end
