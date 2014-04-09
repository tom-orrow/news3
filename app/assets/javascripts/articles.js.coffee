$(document).ready ->
  set_search_actions()
  show_page_sidebox_sticker()
  set_authentication_ajax()
  set_admin_delete_article_ajax()
  set_admin_delete_comment_ajax()
  set_article_preview_ajax()
  close_alert_on_click()
  set_focus()

set_search_actions = () ->
  $('form#search a').click () ->
    $(this).parent().css { left: '0px' }
    $(this).parent().addClass('active')
    $(this).children('.arrow-right').hide()
    $(this).siblings('input').focus()
    return false

  $(document).mouseup (e) ->
    search_form = $('form#search')
    if !search_form.is(e.target) && search_form.has(e.target).length == 0 && search_form.hasClass('active')
      search_form.removeClass('active')
      search_form.css { left: '-300px' }
      search_form.find('a .arrow-right').show()
      search_form.children('input').val('')

show_page_sidebox_sticker = () ->
  $(window).scroll (e) ->
    if $(this).scrollTop() > 700 && $('.col-xs-4#side_box').css('position') != 'fixed'
      $('div#side_box').css({'position': 'fixed', 'top': '10px'})
    else
      $('div#side_box').css({'position': 'absolute', 'top': '0px'})








set_focus = () ->
  $('#sign_in_form, #sign_up_form').on 'shown', () ->
    $('input#user_email').focus()

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

set_article_preview_ajax = () ->
  $('#new_article a#preview_article_btn').click (event) ->
    event.preventDefault()
    $.post($(this).attr('href'), $('#new_article form').serialize(), (data) ->
      if typeof data.errors != 'undefined'
        $('p#article_flash_error').html(data.errors.join('<br />'))
        $('p#article_flash_error').removeClass('hidden')
        $("html, body").animate({scrollTop: 0}, 100)
      else
        $('p#article_flash_error').html('')
        $('p#article_flash_error').addClass('hidden')
        $('.content-box').addClass('hidden')
        $('#preview_article_btn').addClass('hidden')
        $('#cancel_btn').addClass('hidden')
        $('#submit_article_btn').removeClass('hidden')
        $('#edit_article_btn').removeClass('hidden')
        $('#preview_article').html(data)
        title_pic = document.getElementById('article_title_pic').files
        if title_pic != undefined && title_pic.length > 0
          title_pic = title_pic[0]
          reader = new FileReader()
          reader.onload = (event) ->
            image = new Image()
            image.src = event.target.result
            image.onload = () ->

              $('div.titlepic_thumb img').attr('src', event.target.result)
              height_bigger_then_width = this.width / $('div.titlepic_thumb').width() <= this.height / $('div.titlepic_thumb').height()
              $('div.titlepic_thumb img').css {
                position: 'absolute',
                'max-width': `height_bigger_then_width ? '100%' : 'none'`,
                'max-height': `height_bigger_then_width ? 'none' : '100%'`,
              }
              $('div.titlepic_thumb img').css {
                marginTop: '-' + Math.round(($('div.titlepic_thumb img').height() - $('div.titlepic_thumb').height()) / 2) + 'px',
                marginLeft: '-' + Math.round(($('div.titlepic_thumb img').width() - $('div.titlepic_thumb').width()) / 2) + 'px'
              }

              height_bigger_then_width = this.width / $('div.titlepic_original').width() <= this.height / $('div.titlepic_original').height()
              $('div.titlepic_original img').attr('src', event.target.result)
              $('div.titlepic_original img').css {
                position: 'absolute',
                'max-width': `height_bigger_then_width ? '100%' : 'none'`,
                'max-height': `height_bigger_then_width ? 'none' : '100%'`,
              }
              $('div.titlepic_original img').css {
                marginTop: '-' + Math.round(($('div.titlepic_original img').height() - $('div.titlepic_original').height()) / 2) + 'px',
                marginLeft: '-' + Math.round(($('div.titlepic_original img').width() - $('div.titlepic_original').width()) / 2) + 'px'
              }

              $("html, body").animate({scrollTop: 0}, 100)
          reader.readAsDataURL(title_pic)
    )
  $('#new_article a#edit_article_btn').click (event) ->
    event.preventDefault()
    $('.content-box').removeClass('hidden')
    $('#preview_article_btn').removeClass('hidden')
    $('#cancel_btn').removeClass('hidden')
    $('#submit_article_btn').addClass('hidden')
    $('#edit_article_btn').addClass('hidden')
    $('#preview_article').html('')
    $("html, body").animate({scrollTop: 0}, 100)

set_admin_delete_article_ajax = () ->
  $('div.span5.content-box .button-delete').bind 'ajax:success', (e, data, status, xhr) ->
    if data.success
      $(this).parent().parent().fadeOut('slow', () ->
        $(this).remove()
      )

set_admin_delete_comment_ajax = () ->
  $('div.comments .button-delete').bind 'ajax:success', (e, data, status, xhr) ->
    if data.success
      $(this).parent().parent().parent().fadeOut('slow', () ->
        $(this).remove()
      )

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
