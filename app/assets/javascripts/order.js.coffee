# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# Place all the behaviors and hooks related to the matching controller here.
#
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ($) ->

  $(".box_tipo_pedido").hide()
  $("#pedido_colecao").hide()

  hide= ->
    $("a#botao_pedido_detalhes").text "ocultar detalhes"
    $("#pedido_colecao").slideToggle()

  show= ->
    $("a#botao_pedido_detalhes").text "exibir detalhes"
    $("#pedido_colecao").slideToggle()

  $("a#botao_pedido_detalhes").toggle(hide,show)


  $("#pedido_formas_pagamento a").click (e) ->
    e.preventDefault()
    type=$(@).attr("rel")
    $(".box_tipo_pedido").hide()
    $("#pedido_#{type}").slideDown()
