class NewsletterMailer < ActionMailer::Base
  default from: Figaro.env.mailer_sender

  def newsletter(user, subject, body)
    @body = body.gsub(/{{email}}/, user.email)
    locale = user.preferred_language.to_sym || I18n.default_locale

    I18n.with_locale(locale) do
      mail to: user.email, subject: subject
    end
  end
end
