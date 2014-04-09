#= require active_admin/base

$(document).ready ->
  $('#show_reject_modal').click () ->
    $('div#reject_msg_modal').removeClass('hidden')
  $('#hide_reject_modal').click () ->
    $('div#reject_msg_modal #reason').val('')
    $('div#reject_msg_modal').addClass('hidden')
