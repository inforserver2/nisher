$(document).ready(function(){
  var fetchingInc = false;
  $("#cart_inc_button").click(function(e){
    e.preventDefault();
    if (fetchingInc) {
      fetchingInc.abort();
    }
    fetchingInc = $.ajax({
      url: $(this).attr("href"),
      type: "PUT",
      cache: false,
      complete: function(result){
        fetchingInc = false;
      }
    })
    return false;
  })


  $(".frete_tipo").live("change", function(){
     $('div#set_frete').slideUp();
    $.post("/carrinho/set_frete", {frete_tipo:$(this).val()}, function(data){
     $('div#set_frete').html(data).fadeIn();
    });
  });

  $("#link_calcular_frete").click(function(e){
  e.preventDefault();
  $('div#address_completed, div#frete_info, div#set_frete').empty();
  $('div#address_colect').show();
  $('form#address_input').show();
  $('#calculo_frete').fadeIn();
 });

 $("#link_alterar_dados").live("click",function(e){
  e.preventDefault();
  $('div#address_completed, div#frete_info, div#set_frete').empty().hide();
  $('div#address_colect').show();
  $('form#address_input').show();
  $('#calculo_frete').fadeIn();
 });

  $('#address_input')
    .live("ajax:beforeSend", function(evt, xhr, settings){
      var $submitButton = $(this).find('input[name="commit"]');
      $submitButton.val("Enviando...");
    })

    .live("ajax:success", function(evt, data, status, xhr){
      $('form#address_input').remove();
      $('div#address_completed').load("/carrinho/address_completed").show();
      $('#address_colect').load("/carrinho/address_input").hide();
      $('div#frete_info').load("/carrinho/frete_info").show();
      $('html, body').scrollTop($("#address_completed").offset().top);

    })

    .live('ajax:complete', function(evt, xhr, status){
      var $submitButton = $(this).find('input[name="commit"]');
      $submitButton.val("Atualizar");
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
      $form.remove();
      $('#address_colect').html( toInsert );
      $('html, body').scrollTop($("#address_input").offset().top);
      alert("Para continuar é necessário que verifique as pendências e tente novamente!");
      //$('html, body').animate({scrollTop: $("#address_input").offset().top }, 2000);
    });


});
