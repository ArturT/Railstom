class LocalePageFinder < HighVoltage::PageFinder
  def find
    "#{content_path}#{I18n.locale}/#{clean_path}"
  end
end
