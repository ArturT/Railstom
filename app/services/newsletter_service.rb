class NewsletterService
  takes :newsletter_id, :recipients_limit

  def run
    process if can_be_send?
  end

  def can_be_send?
    !newsletter.nil? && !newsletter.stopped? && newsletter.finished_at.nil?
  end

  def newsletter
    # won't raise exception when someone removed record from db
    @newsletter ||= Newsletter.find_by(id: newsletter_id)
  end

  def process
    recipients.empty? ? mark_as_finished : send_newsletter
  end

  def recipients
    @recipients ||= newsletter.language.blank? ? recipients_all : recipients_with_preferred_language
  end

  def recipients_all
    User.where('id > ?', last_user_id).take(recipients_limit)
  end

  def recipients_with_preferred_language
    User.where('id > ?', last_user_id).where(preferred_language: newsletter.language).take(recipients_limit)
  end

  def last_user_id
    newsletter.last_user_id
  end

  def mark_as_finished
    newsletter.update_attribute(:finished_at, DateTime.now)
  end

  def send_newsletter
    last_user_id = self.last_user_id
    sent_email_count = 0

    begin
      recipients.each do |user|
        if can_send_to_user?(user)
          send_to_user(user)
          sent_email_count += 1
        end

        # update last_user_id when email was sent correctly
        last_user_id = user.id
      end

      return :continue
    ensure
      new_sent_email_count = newsletter.sent_email_count + sent_email_count
      newsletter.update_attributes(
        last_user_id: last_user_id,
        sent_email_count: new_sent_email_count
      )
    end
  end

  def can_send_to_user?(user)
    user.enabled_newsletter? || newsletter.enabled_force?
  end

  def send_to_user(user)
    NewsletterMailer.newsletter(user, newsletter.subject, newsletter.body).deliver
  end
end
