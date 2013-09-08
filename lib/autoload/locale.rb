class Locale
  class << self
    def supported_languages
      @@supported_languages ||= Figaro.env.supported_languages.strip.split(' ')
    end

    # locale can be symbol or string, i.e. :en, 'en'
    def supported_language?(locale)
      self.supported_languages.include?(locale.to_s)
    end

    def collection_of_languages
      @@collection_languages ||= {}
      if @@collection_languages.empty?
        supported_languages.each do |locale|
          @@collection_languages[I18n.name_for_locale(locale)] = locale
        end
      end
      @@collection_languages
    end
  end
end
