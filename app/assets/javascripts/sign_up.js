$(document).ready(function(){
  $('#new_user_form')
    .live("ajax:beforeSend", function(evt, xhr, settings){
      var $submitButton = $(this).find('input[name="commit"]');
      $submitButton.val("Enviando...");
    })

    .live("ajax:success", function(evt, data, status, xhr){
    })

    .live('ajax:complete', function(evt, xhr, status){
      var $submitButton = $(this).find('input[name="commit"]');
      $submitButton.val("Continuar com o cadastro");
    })
    .live("ajax:error", function(evt, xhr, status, error){
      var $form = $(this),
          errors,
          errorText;

      try {
        // Populate errorText with the comment errors
        errors = $.parseJSON(xhr.responseText);
      } catch(err) {
        // If the responseText is not valid JSON (like if a 500 exception was thrown), populate errors with a generic error message.
        errors = {message: "Ocorreu um erro inesperado, atualize a página e tente novamente!"};
      }
      var toInsert = $(xhr.responseText)
      $('#new_user_form').html( toInsert ).show();
      $("#user_cpf, #user_respons_cpf").mask("999.999.999-99");
      $("input:[alt=phone], input:[alt=mobile]").mask("(99) 9999-9999");
      $("#user_cnpj").mask("99.999.999/9999-99");
      $('form div#pessoa_juridica, form div#pessoa_fisica').hide();
      person_type_id=$('form .person_type_select:checked').val();
      account_type_id=$('form #user_account_type_id').val();
      if (account_type_id==="1"){
        $('form div#pessoa_juridica').hide();
        $('form div#login_place').hide();
        $('form div#bank_account_place').hide();
        $('form div#pessoa_fisica').slideDown();
      } else if (account_type_id==="2"){
        $('form div#pessoa_fisica').hide();
        $('form div#login_place').show();
        $('form div#pessoa_juridica').slideDown();
      }
      $('html, body').scrollTop($("#site_form_new_user").offset().top);
      if (person_type_id==1){
        $("#user_person_type_id_1").click();
      } else if (person_type_id==2){
        $("#user_person_type_id_2").click();
      }
      alert("Para continuar é necessário que verifique as pendências e tente novamente!");
    });


});