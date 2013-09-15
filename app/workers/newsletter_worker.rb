class NewsletterWorker
  include Sidekiq::Worker
  sidekiq_options queue: :newsletter

  RECIPIENTS_LIMIT = 20
  INTERVAL = 60 # in seconds

  def perform(newsletter_id)
    newsletter_service = NewsletterService.new(newsletter_id, RECIPIENTS_LIMIT)

    # perform next newsletter only when this passed
    if newsletter_service.run == :continue
      NewsletterWorker.perform_at(interval_seconds_from_now, newsletter_id)
    end
  end

  def interval_seconds_from_now
    INTERVAL.seconds.from_now
  end
end
