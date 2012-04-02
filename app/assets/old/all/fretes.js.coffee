$(document).ready ->
  $("input.frete_tipo").change (e)->
    e.preventDefault()
    type=$(this).val()
    $.ajax
      type: 'put'
      url: "/frete/#{type}" 
      beforeSend: ->
        $("#valor_final_a_pagar").html("carregando...")
      data: {type:type}
      dataType: 'json'
      success: (json) ->
        $("#valor_final_a_pagar").html(json.price)
    
