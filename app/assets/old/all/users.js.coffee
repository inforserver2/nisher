# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->

  $('#login_place input#user_name').live "keyup", ->
    if (this.value.match(/[^a-zA-Z0-9]/g))
      this.value = this.value.replace(/[^a-zA-Z0-9]/g, '')

  $('#login_place input#user_name').live "blur", ->
    $('div#check_for_user').load("/check_for_name/#{$('#login_place input#user_name').val()}")

  $('#user_email1').live "blur", ->
    $('div#check_for_email').load("/check_for_email?email=#{$('#user_email1').val()}")


  $('#new_user_option_1').live "click", (e)->
    e.preventDefault()
    $('input#user_account_type_id').val("1")
    $('form div#login_place, form div#bank_account_place').hide()
    $('#question1').slideUp(->
      $('#cufon_question h1').html("Tipo de cliente: #{$("#new_user_option_1").attr("alt")} [Mudar]")
      $('#cufon_question').slideToggle()
    )
    $('#new_user_form').slideDown()

  $('#new_user_option_2').live "click", (e)->
    e.preventDefault()
    $('input#user_name').val("")
    $('input#user_account_type_id').val("2")
    $('form div#login_place, form div#bank_account_place').show()
    $('#question1').slideUp(->
      $('#cufon_question h1').html("Tipo de cliente: #{$("#new_user_option_2").attr("alt")} [Mudar]")
      $('#cufon_question').slideToggle()
    )
    $('#new_user_form').slideDown()

  $('#cufon_question').live "click", ->
    $(this).hide()
    $('#question1').slideDown()
    $('#new_user_form').slideUp()


  hide = ->
    func = ->
      $(@).text("[ocultar detalhes]").fadeIn()
    $("div#cufon_cart h1 span").fadeOut(func)
  show = ->
    func = ->
      $(@).text("[exibir detalhes]").fadeIn()
    $("div#cufon_cart h1 span").fadeOut(func)
  $("div#cufon_cart").toggle(hide,show)
  $('div#cufon_cart').live "click", (e) ->
    e.stopPropagation()
    $('div#cufon_cart_data').slideToggle()




  $('form div#pessoa_juridica, form div#pessoa_fisica').hide()
  person_type_id=$('form .person_type_select:checked').val()

  $('form .person_type_select').live "click", (e)->
    it = $(this).val()
    if it == "1"
      $('input#user_person_type_id').val("1")
      $('form div#pessoa_juridica').hide()
      $('form div#pessoa_fisica').slideDown()
    else if it == "2"
      $('input#user_person_type_id').val("2")
      $('form div#pessoa_fisica').hide()
      $('form div#pessoa_juridica').slideDown()


  $("form #user_person_type_id_#{person_type_id}").click()

  $('a.nisher_button2').live "click" ->
    alert $(this).val()
