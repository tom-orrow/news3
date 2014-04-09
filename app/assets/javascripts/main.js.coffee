$(document).ready ->
  $("#sign_up_form form").bind "ajax:success", (e, data, status, xhr) ->
    $("#sign_up_form p.alert").html('').addClass('hidden')
    if data.success
      $('#sign_up_form').modal('hide')
      $('#flash_notice').html(data.notice)
      $('#flash_notice').removeClass('hidden')
    else
      $("#sign_up_form p.alert").html(data.errors.join("<br />"))
      $("#sign_up_form p.alert").removeClass('hidden')

  $("#sign_in_form form").bind "ajax:success", (e, data, status, xhr) ->
    $("#sign_in_form p.alert").html('').addClass('hidden')
    if data.success
      window.location.replace("/")
    else
      $("#sign_in_form p.alert").html(data.errors.join("<br />"))
      $("#sign_in_form p.alert").removeClass('hidden')

  $('.alert').click () ->
    $(this).html('').addClass('hidden')

