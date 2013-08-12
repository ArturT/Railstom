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

  # Generate li elements for html list
  #
  # Params:
  # @param *items [Array<Hash>] array of hashes
  #   Params for each hash in above array:
  #   @param name [String] link name
  #   @param icon [String optional] awesome fonts class for icon i.e. icon-lock
  #   @param path [String or Array<String, Hash>] URI for href, first element in Array is default path. Hash i.e. {controller: 'registrations', action: 'update'}
  #   @param condition [Boolean optional] when true or nil link will be displayed
  #   @param data [Hash optional] html data attributes
  # @return [String]
  def menu_items(*items)
    items = items.map do |item|
      if item[:condition] || item[:condition].nil?
        menu_items = nil

        if item[:path].kind_of?(Array)
          paths = item[:path]
        else
          paths = [item[:path]]
        end

        class_name = nil
        paths.each do |path|
          if path.kind_of?(Hash)
            class_name = 'active' if params[:controller] == path[:controller] and params[:action] == path[:action]
          elsif current_page?(path)
            class_name = 'active'
          end
        end

        icon = item[:icon].nil? ? '' : %{<i class="#{item[:icon]}"></i>}
        link_name = "#{icon} #{item[:name]}"
        menu_items = %Q{<li class="#{class_name}">#{link_to raw(link_name), paths[0], method: item[:method], data: item[:data]}</li>}

        if item[:divider]
          menu_items << %Q{<li class="divider"></li>}
        end
      end

      menu_items
    end

    raw items.join
  end

  def copyright_year(year)
    str = "&copy; #{year}"
    current_year = Time.zone.now.year
    str << " - #{current_year}" if current_year > year.to_i
    raw(str)
  end
end
