# Example:
# loadIcon="prepend" add icon prepend
# loadIcon="append" add icon append
# loadIcon="#id|.class" add the load icon to specify element
# loadIconMargin="left:5px|right:10px" [optional] add specify margin on the left or right side of the icon
# loadIconSize="fa-lg" [optional] add class fa-lg, fa-2x, fa-3x etc to the icon
angular.module('App.directives.railstom').directive 'loadIcon', ->
  (scope, element, attrs) ->
    element.attr('data-no-turbolink', true)
    element.click (e) ->
      # Don't run twice when double click
      if $(this).hasClass('prevent-default')
        e.preventDefault()
      else
        $(this).addClass('prevent-default')

        if attrs.loadIconMargin?
          style = "margin-#{attrs.loadIconMargin};"
        else
          style = ""

        icon = """<i class="fa fa-spin fa-refresh #{attrs.loadIconSize}" style="#{style}"></i>"""

        switch attrs.loadIcon
          when 'prepend' then element.prepend(icon)
          when 'append' then element.append(icon)
          else $(attrs.loadIcon).html(icon)
