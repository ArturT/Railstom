class Locale
  class << self
    def supported_languages
      @@supported_languages ||= Figaro.env.supported_languages.strip.split(' ')
    end

    # locale can be symbol or string, i.e. :en, 'en'
    def supported_language?(locale)
      self.supported_languages.include?(locale.to_s)
    end
  end
end
