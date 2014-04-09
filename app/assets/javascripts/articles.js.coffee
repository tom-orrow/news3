$(document).ready ->
  set_authentication_ajax()
  close_alert_on_click()

set_authentication_ajax = () ->
  $('#sign_up_form form').bind 'ajax:success', (e, data, status, xhr) ->
    $('#sign_up_form p.alert').html('').addClass('hidden')
    if data.success
      $('#sign_up_form').modal('hide')
      $('#flash_notice').html(data.notice)
      $('#flash_notice').removeClass('hidden')
    else
      $('#sign_up_form p.alert').html(data.errors.join('<br />'))
      $('#sign_up_form p.alert').removeClass('hidden')

  $('#sign_in_form form').bind 'ajax:success', (e, data, status, xhr) ->
    $('#sign_in_form p.alert').html('').addClass('hidden')
    if data.success
      window.location.replace('/')
    else
      $('#sign_in_form p.alert').html(data.errors.join('<br />'))
      $('#sign_in_form p.alert').removeClass('hidden')

close_alert_on_click = () ->
  $('.alert').click () ->
    $(this).html('').addClass('hidden')

root = exports ? this
root.reply_comment = (id, elem) ->
  empty_comment_parent_on_click()
  $('#comment_parent_id').val(id)
  parent = $(elem).parent().parent()
  $(parent).addClass('reply')
  $('#new_comment textarea').focus()
  fullname = parent.children('h4').html()
  $('#new_comment h2').html('Add Reply to ' + fullname)
  $('button#reset_reply').show()

root.empty_comment_parent_on_click = () ->
  $('button#reset_reply').hide()
  $('#comment_parent_id').val(null)
  $('div.media-body.reply').removeClass('reply')
  $('#new_comment h2').html('Add Comment')
