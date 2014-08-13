$(document).ready ->
  $('form.validate').submit () ->
    form_valid = validate_form($(this))
    if !form_valid
      return false
  $('form.validate input').focusout () ->
    validate_field $(this)

error = null
form_valid = true

validate_form = (form) ->
  form_valid = true
  $.each form.find('input:not([type=hidden], [type=checkbox])'), (i, field) ->
    validate_field($(field))

validate_field = (field)->
  error = null
  check_default_validations(field)
  unless error
    type = get_field_type(field)
    switch type
      when 'text' then check_text_field(field)
      when 'password' then check_password_field(field)
      when 'password_confirm' then check_password_confirm_field(field)
      when 'textarea' then check_textarea_field(field)
      when 'email' then check_email_field(field)

  if error
    display_error() unless $(field).next().hasClass('input_error')
    form_valid = false
  else
    remove_error(field)

get_field_type = (field) ->
  return 'text' if field.attr('type') == 'text'
  return 'password_confirm' if field.attr('type') == 'password' && field.attr('id').match(/.*_confirmation$/)
  return 'password' if field.attr('type') == 'password'
  return 'email' if field.attr('type') == 'email'

display_error = () ->
  $(error[0]).after('<i class="fa fa-exclamation input_error" data-toggle="tooltip" data-content="' + error[1] + '"></i>')
  $('i[data-toggle="tooltip"]').hover(
    () -> $(this).append('<span class="tooltip">' + $(this).data('content') + '</span>')
    () -> $(this).children('.tooltip').remove()
  )

remove_error = (field) ->
  $(field).next('i.input_error').remove()

## Checks
check_default_validations = (field) ->
  error = [field, 'Value is too short. Minimum 3 chars long.'] if $(field).val().length < 3
  error = [field, 'Value is too long. Maximum 20 chars long.'] if $(field).val().length > 20
check_text_field = (field) ->
check_password_field = (field) ->
check_password_confirm_field = (field) ->
  password_field_id = $(field).attr('id').match(/^(.*)_confirmation$/)[1]
  error = [field, 'Password confirmation and password are not equal.'] if $(field).val() != $(field).siblings('#' + password_field_id).val()
check_textarea_field = (field) ->
check_email_field = (field) ->
  error = [field, 'Wrong email format.'] unless $(field).val().match(/.*@.*\..*/)
