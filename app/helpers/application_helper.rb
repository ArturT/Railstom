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
    content_tag :div, class: "alert-box #{css_class}", data: { alert: nil } do
      content_tag :div, class: 'row' do
        raw(%{#{message} <a href="#" class="close">&times;</a>})
      end
    end
  end
end
