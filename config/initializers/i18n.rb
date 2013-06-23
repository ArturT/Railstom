# https://gist.github.com/henrik/276191
module I18n

  def self.name_for_locale(locale)
    I18n.backend.translate(locale, 'i18n.language.name')
  rescue I18n::MissingTranslationData
    locale.to_s
  end

end
