#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap-sprockets

autoload_events = (page) ->
  events_path = $('table').data('events-path')
  $.getJSON "#{events_path}?page=#{page}", (response) ->
    $('table').data('page', response.data.pagination.page)
    $('table').data('next-page', response.data.pagination.next_page)
    html = []
    $.each response.data.events, (index, event) ->
      html.push "<tr><td>#{event.operator}</td><td>#{event.action}</td>" +
          "<td>#{event.resource_name}: <a href='#{event.link}'>#{event.title}</a></td>" +
          "<td>#{event.content}</td></tr>"
    $('table').append(html.join(''))

$(window).scroll ->
  if $(window).scrollTop() == $(document).height() - $(window).height()
    next = $('table').data('page') + 1
    if next <= $('table').data('next-page')
      autoload_events next

ready = ->
  if window.location.href.match(/events/)
    $('table').data('page', 1)
    $('table').data('next-page', 2)
    autoload_events($('table').data('page'))

$(document).on('turbolinks:load', ready)

