class NewsletterWorker
  include Sidekiq::Worker
  sidekiq_options queue: :newsletter

  USERS_LIMIT = 20
  INTERVAL = 60 # in seconds

  def perform(newsletter_id)
    # won't raise exception when someone removed record from db
    newsletter = Newsletter.find_by(id: newsletter_id)

    if !newsletter.nil? && !newsletter.stopped?
      last_user_id = newsletter.last_user_id
      users = User.where('id > ?', last_user_id).take(USERS_LIMIT)

      if users.empty?
        newsletter.update_attribute(:finished_at, DateTime.now)
      else
        sent_email_count = 0
        begin
          users.each do |user|
            if user.enabled_newsletter? || newsletter.enabled_force?
              # send mail
              # TODO add mailer

              # when email sent
              sent_email_count += 1
            end
            # update last_user_id when email was sent correctly
            last_user_id = user.id
          end
        ensure
          new_sent_email_count = newsletter.sent_email_count + sent_email_count
          newsletter.update_attributes(
            last_user_id: last_user_id,
            sent_email_count: new_sent_email_count
          )
          NewsletterWorker.perform_at(INTERVAL.seconds.from_now, newsletter_id)
        end
      end
    end
  end
end
