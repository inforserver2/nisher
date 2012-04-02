# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

jQuery ($) ->
  $("#net_signup_form").hide()
  $("a#net_activate").click (e) ->
    e.preventDefault()
    $("#net_signup_form").slideDown()

  src1=$('#net_signup_form')
  src1
    .live( "ajax:beforeSend",(evt, xhr, settings) ->
      submitButton = $(@).find 'input[name="commit"]'
      submitButton.val "Enviando..."
    )
    .live("ajax:success",(evt, data, status, xhr) ->
    )
    .live('ajax:complete',(evt, xhr, status) ->
    )
    .live("ajax:error",(evt, xhr, status, error) ->
      form = $(@)
      try
        # Populate errorText with the comment errors
        errors = $.parseJSON xhr.responseText
      catch err
        # If the responseText is not valid JSON (like if a 500 exception was thrown), populate errors with a generic error message.
        errors = message: "Ocorreu um erro inesperado, atualize a página e tente novamente!"

      toInsert = $(xhr.responseText).find("#net_signup_form")

      src1.html( toInsert ).show()

      $('html, body').scrollTop(src1.offset().top)
    )
