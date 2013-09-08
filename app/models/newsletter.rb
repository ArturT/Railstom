class Newsletter < ActiveRecord::Base
  validates :subject, :body, presence: true

  after_create :send_newsletter
  after_update :resume_newsletter

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
end
