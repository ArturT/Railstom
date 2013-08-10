# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require foundation
#= require angular
#= require angular-resource
#= require ng-rails-csrf
#= require i18n
#= require i18n/translations
#
# TODO add manual files which should be included
#= require global
#
#= require_tree ../../../vendor/assets/javascripts/.

$ ->
  $(document).foundation()
  window.lazyImageLoader('body')

  # scroll to errors
  window.goToByScroll('.simple_form div.error', 0, 70)

  # get rid of facebook hash
  window.location.hash = '' if window.location.hash == '#_=_'

  # scroll to achor
  # facebook hash has to be removed earlier
  if window.location.hash && /^#_/.test(window.location.hash)
    hash = window.location.hash.replace(/^#_/,'#')
    window.goToByScroll(hash, 0, 30)

  # alert close will run at the same time as zurb foundation animation which is binded to .close class
  $('.alert-close').click ->
    $(this).parent().parent().slideUp()
