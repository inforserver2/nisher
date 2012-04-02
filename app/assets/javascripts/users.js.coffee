# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->

  $('#new_user_form input#user_name, #net_signup_form input#user_name, #login_place input#user_name').live "keyup", ->
    if (this.value.match(/[^a-zA-Z0-9]/g))
      this.value = this.value.replace(/[^a-zA-Z0-9]/g, '')

  $('#new_user_form input#user_name, #net_signup_form input#user_name, #login_place input#user_name').live "blur", ->
    $('div#check_for_user').load("/check_for_name/#{$(this).val()}")

  $('#user_email1').live "blur", ->
    $('div#check_for_email').load("/check_for_email?email=#{$('#user_email1').val()}")


  $('#new_user_option_1').live "click", (e)->
    e.preventDefault()
    $('input#user_account_type_id').val("1")
    $('form div#login_place, form div#bank_account_place').hide()
    $('#question1').slideUp()
    $('#cufon_question').toggle()
    $('#cufon_question h1').html("Tipo de cliente: #{$("#new_user_option_1").attr("alt")}<span id=cufon_cart_change_type> [mudar]<span>")
    $('#new_user_form').slideDown()

  $('#new_user_option_2').live "click", (e)->
    e.preventDefault()
    $('input#user_name').val("")
    $('input#user_account_type_id').val("2")
    $('form div#login_place, form div#bank_account_place').show()
    $('#question1').slideUp()
    $('#cufon_question').toggle()
    $('#cufon_question h1').html("Tipo de cliente: #{$("#new_user_option_2").attr("alt")}<span id=cufon_cart_change_type> [mudar]<span>")
    $('#new_user_form').slideDown()

  $('#cufon_question').live "click", ->
    $(this).hide()
    $('#question1').slideDown()
    $('#new_user_form').slideUp()


  $('div#cufon_cart').live "click", ->
    $('span#cufon_cart_details').remove()
    $('div#cufon_cart_data').slideDown()



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

  $('a.nisher_button2').live "click", (e)->
    e.preventDefault()
    alert $(this).attr("alt")
