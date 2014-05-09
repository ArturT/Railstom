class MenuItem
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::OutputSafetyHelper

  attr_reader :params, :request, :items

  # Params:
  # @param items [Array<Hash>] array of hashes
  #   Params for each hash in above array:
  #   @param name [String] link name
  #   @param icon [String optional] awesome fonts class for icon i.e. fa-lock
  #   @param path [String or Array<String, Hash>] URI for href, first element in Array is default path. Hash i.e. {controller: 'registrations', action: 'update'}
  #   @param condition [Boolean optional] when true or nil link will be displayed
  #   @param data [Hash optional] html data attributes
  def initialize(params, request, items)
    @params = params
    @request = request
    @items = items
  end

  # render li elements for html list
  def render
    menu_items = items.map do |item|
      generate_item(item)
    end

    raw menu_items.join
  end

  private

  def generate_item(item)
    if has_visible_item(item)
      menu_item = list_item(item)
      menu_item << divider if item[:divider]
    end
    menu_item
  end

  def has_visible_item(item)
    item[:condition] || item[:condition].nil?
  end

  def list_item(item)
    paths = item_paths(item)
    css_class = has_active_class_for_any_paths(paths)
    link_name = raw(link_name(item))

    %Q{<li class="#{css_class}">#{link_to(link_name, paths[0], method: item[:method], data: item[:data])}</li>}
  end

  def item_paths(item)
    if item[:path].kind_of?(Array)
      item[:path]
    else
      [item[:path]]
    end
  end

  def has_active_class_for_any_paths(paths)
    css_class = nil
    paths.each do |path|
      css_class ||= has_active_class_for_path(path)
    end
    css_class
  end

  def has_active_class_for_path(path)
    if path.kind_of?(Hash)
      :active if has_controller_action(path)
    elsif current_page?(path)
      :active
    end
  end

  def has_controller_action(path)
    params[:controller] == path[:controller] and params[:action] == path[:action]
  end

  def link_name(item)
    "#{item_icon(item)} #{item[:name]}"
  end

  def item_icon(item)
    item[:icon].nil? ? '' : %{<i class="fa #{item[:icon]}"></i>}
  end

  def divider
    %Q{<li class="divider"></li>}
  end
end
