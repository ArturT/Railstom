module UserSettingsHelper
  def display_link_to_connect_with_provider(provider, icon, link_message, linked_message)
    icon_html = %{<i class="icon-#{icon} icon-large"></i>}

    if current_user.has_provider?(provider)
      raw "#{icon_html} #{linked_message}"
    else
      link_to raw("#{icon_html} #{link_message}"), user_omniauth_authorize_path(provider), data: { 'load-icon' => 'append', 'load-icon-margin' => 'left:10px' }
    end
  end
end
