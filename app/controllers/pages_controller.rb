class PagesController < HighVoltage::PagesController
  def locale_show
    render locale_current_page
  end

  private

  def locale_current_page
    locale_page_finder.find
  end

  def locale_page_finder
    locale_page_finder_factory.new(params[:id])
  end

  def locale_page_finder_factory
    LocalePageFinder
  end
end
