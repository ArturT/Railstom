# https://gist.github.com/henrik/276191
module I18n

  def self.name_for_locale(locale)
    I18n.backend.translate(locale, 'i18n.language.name')
  rescue I18n::MissingTranslationData
    locale.to_s
  end

end

# Skip message:
# [deprecated] I18n.enforce_available_locales will default to true in the future. If you really want to skip validation of your locale you can set I18n.enforce_available_locales = false to avoid this message.
I18n.enforce_available_locales = false
