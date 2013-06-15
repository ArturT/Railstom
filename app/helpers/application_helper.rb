module ApplicationHelper
  def alert_box(css_class, message)
    content_tag :div, class: "alert-box #{css_class}", data: { alert: nil } do
      content_tag :div, class: 'row' do
        raw(%{#{message} <a href="#" class="close">&times;</a>})
      end
    end
  end
end
