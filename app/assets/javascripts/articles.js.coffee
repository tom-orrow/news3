$(document).ready ->
  set_index_header_articles_hovering()
  prepare_navbar()
  prepare_reviews_carousel()
  prepare_autosizing()
  show_page_sidebox()
  set_authentication_ajax()
  set_other_actions()
  set_article_preview_ajax()
  # set_admin_delete_article_ajax()
  # set_admin_delete_comment_ajax()

  # close_alert_on_click()

set_index_header_articles_hovering = () ->
  $('#index_header_articles a').hover () ->
    $(this).parent().toggleClass('highlight')

hoverTimer = null
navbarShown = false
prepare_navbar = () ->
  if $('#index_header_articles').length > 0
    $(window).scroll (e) ->
      if $(this).scrollTop() > 450
        $('#header_navbar').addClass('navbar-fixed-top')
      else
        $('#header_navbar').removeClass('navbar-fixed-top')
  else
    $('#header_navbar').addClass('navbar-fixed-top')

  $('#categories_menu li').hover () ->
    hoveredLi = $(this)
    if navbarShown
      hoveredLi.children('.nav_sub').show()
    else
      hoverTimer = setTimeout () ->
        navbarShown = true
        hoveredLi.children('.nav_sub').show()
      , 300
  , (e) ->
    window.clearTimeout(hoverTimer)
    $(this).children('.nav_sub').hide()
    $(this).find('.nav_sub_categories > li').removeClass('active')
    $(this).find('.nav_sub_categories > li:first-child').addClass('active')

  $('#categories_menu').mouseleave () ->
    navbarShown = false

  $('.nav_sub_categories > li:not(:last-child) a').hover () ->
    $(this).parent().siblings('li').removeClass('active')
    $(this).parent().addClass('active')

  $('#search').click () ->
    $(this).find('form input').focus()

reviews_carousel_offset = 0
prepare_reviews_carousel = () ->
  $('.reviews_carousel_wrapper .controls').click () ->
    if $(this).hasClass('prev') && !$(this).hasClass('inactive')
      $(this).siblings('.reviews_carousel').animate({left: (reviews_carousel_offset + 240) + 'px'}, 300)
      $(this).siblings('.next').removeClass('inactive')
      reviews_carousel_offset += 240
      if reviews_carousel_offset == 0
        $(this).addClass('inactive')
    if $(this).hasClass('next') && !$(this).hasClass('inactive')
      $(this).siblings('.reviews_carousel').animate({left: (reviews_carousel_offset - 240) + 'px'}, 300)
      $(this).siblings('.prev').removeClass('inactive')
      reviews_carousel_offset -= 240
      if $(this).siblings('.reviews_carousel').width() + reviews_carousel_offset == 960
        $(this).addClass('inactive')
    return false;

prepare_autosizing = () ->
  resize_blocks()
  $(window).resize () ->
    resize_blocks()

resize_blocks = () ->
  fullWidth = $('#header_navbar').width()
  fullHeight = $(window).height()
  contentWidth = $('#header_navbar .container').width()

  $('.double_posts').css({
    width: fullWidth + 'px',
    'margin-left': Math.ceil((contentWidth - fullWidth) / 2) + 'px'
  })
  $('#side_box #offers ul').css(height: fullHeight - 92 + 'px')
  $('#side_box #related_categories').css(height: fullHeight + 41 + 'px')

show_page_sidebox = () ->
  scrollOptions = {
    scrollInertia: 0
  }
  $("ul#related_articles").mCustomScrollbar(scrollOptions);
  $("ul#recent_articles").mCustomScrollbar(scrollOptions);

  $(window).scroll (e) ->
    if $(this).scrollTop() > 485 && $('.col-xs-4#side_box').css('position') != 'fixed'
      $('div#side_box').css({'position': 'fixed', 'top': '51px'})
    else
      $('div#side_box').css({'position': 'absolute', 'top': '0px'})

  $('#related_categories ul li').hover () ->
    $(this).addClass('highlight')
  , () ->
    $(this).removeClass('highlight')
  $('#related_categories ul li').click () ->
    if !$(this).hasClass('active')
      $(this).siblings('li').removeClass('active')
      $(this).addClass('active')
      target = $(this).attr('value')
      $('#side_box #offers ul').hide()
      $('#side_box #offers ul#' + target).show()
      $('#side_box #offers ul#' + target).mCustomScrollbar("update")
      $('#side_box #offers ul#' + target).mCustomScrollbar("scrollTo", "top")

set_authentication_ajax = () ->
  $('#sign_in_form ul.nav.nav-tabs li a').click () ->
    $('#sign_in_form #auth_forms ul.nav.nav-tabs li.active').removeClass('active')
    $(this).parent().addClass('active')
    box_id = $(this).attr('href')
    another_box_id = $('#sign_in_form ul.nav.nav-tabs li:not(.active) a').attr('href')
    $(another_box_id).hide()
    $(box_id).show()
    return false

  $('#sign_in_form').on 'show.bs.modal', () ->
    $('div#wrap, div#footer').addClass('blur')
  $('#sign_in_form').on 'hide.bs.modal', () ->
    $('div#wrap, div#footer').removeClass('blur')

  $('#sign_in_form form').bind 'ajax:success', (e, data, status, xhr) ->
    $('#sign_in_form p.alert').html('').addClass('hidden')
    if data.success
      window.location.replace('/')
    else
      $('#sign_in_form p.alert').html(data.errors.join('<br />'))
      $('#sign_in_form p.alert').removeClass('hidden')

  # Show\Hide password recovery form
  $('#password_recover_link').click () ->
    $('#auth_forms').hide()
    $('#restore_password_form').show()
  $('#password_recovery_cancel').click () ->
    $('#restore_password_form').hide()
    $('#auth_forms').show()

set_other_actions = () ->
  if $('#user_menu > a').hasClass('signed')
    $('#user_menu > a').click () ->
      return false;
    $('#user_menu').hover () ->
      $(this).children('#user_btn').addClass('active')
      $(this).children('#user_menu_box').show()
    , () ->
      $(this).children('#user_btn').removeClass('active')
      $(this).children('#user_menu_box').hide()

set_article_preview_ajax = () ->
  $('#new_article a#preview_article_btn').click (event) ->
    event.preventDefault()
    $.post($(this).attr('href'), $('#new_article form').serialize(), (data) ->
      if typeof data.errors != 'undefined'
        $('#article_flash_error').html(data.errors.join('<br />'))
        $('#article_flash_error').removeClass('hidden')
        $("html, body").animate({scrollTop: 0}, 100)
      else
        $('#article_flash_error').html('')
        $('#article_flash_error').addClass('hidden')
        $('#new_article').hide()
        $('#preview_article_btn').hide()
        $('#cancel_btn').hide()
        $('#submit_article_btn').show()
        $('#edit_article_btn').show()
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
