module ApplicationHelper
  # /:locale/pages/*id
  def default_page_path(id)
    page_path(I18n.locale, id)
  end

  # /:locale/locale_pages/*id
  def default_locale_page_path(id)
    locale_page_path(I18n.locale, id)
  end

  def alert_box(css_class, message)
    unless message.nil?
      content_tag :div, class: "alert-box alert-#{css_class}", data: { alert: nil } do
        content_tag :div, class: 'row' do
          raw(%{#{message} <a href="#" class="close alert-close">&times;</a>})
        end
      end
    end
  end

  def menu_items(*items)
    menu = MenuItem.new(params, request, items)
    menu.render
  end

  def copyright_year(year)
    str = "&copy; #{year}"
    current_year = Time.zone.now.year
    str << " - #{current_year}" if current_year > year.to_i
    raw(str)
  end
end
