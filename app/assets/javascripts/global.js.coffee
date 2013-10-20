@onPageLoad = (func) ->
  $(document).ready(func)
  $(document).on('page:load', func)


@goToByScroll = (obj, allowed_margin, up_limit) ->
  if $(obj).length > 0
    allowed_max = allowed_min = current = destination = undefined
    current = $(document).scrollTop()
    destination = $(obj).offset().top
    allowed_min = destination - allowed_margin
    allowed_max = destination + allowed_margin
    destination -= up_limit if destination >= up_limit
    if current < allowed_min or current > allowed_max
      $("html,body").animate { scrollTop: destination }, "slow"


@lazyImageLoader = (parent) ->
  $("#{parent} img").waypoint (event, direction) ->
    img = this
    setTimeout ->
      deferred = $(img).data('deferred')
      src = $(img).attr('src')
      if deferred? && src != deferred
        $(img).animate
          opacity: .01
        , 250
        , ->
          img.src = deferred
        .animate
          opacity: 1
        , 1000
    , 250
  ,
    triggerOnce: true,
    offset: ->
      $.waypoints('viewportHeight') - $(this).height()
