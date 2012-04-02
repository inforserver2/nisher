// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery_ujs
//= require_tree .
//= require superfish
//= require hoverIntent




$(window).load(function() {


  $("input:[alt=phone], input:[alt=mobile]").mask("(99) 9999-9999");
  $("input:[alt=cep]").mask("99999-999");
  $("#user_cpf, #user_respons_cpf").mask("999.999.999-99");
  $("#user_cnpj").mask("99.999.999/9999-99");
  $("#to_value").mask("999.99");
jQuery('.positive').keyup(function () {
    this.value = this.value.replace(/[^0-9\.]/g,'');
});

  $("ul.sf-menu").superfish({
      animation: {height:'show'},   // slide-down effect without fade-in
      delay:     300               // 1.2 second delay on mouseout
  });


  $('div.expander').expander({
    slicePoint: 100,
    widow: 2,
    expandText: 'ler mais',
    userCollapseText: '<<'
  });


  $("a.fancy").fancybox();

  $('#slider').nivoSlider({
        effect:'sliceUpDownLeft', // Specify sets like: 'fold,fade,sliceDown'
        slices:15, // For slice animations
        boxCols: 8, // For box animations
        boxRows: 4, // For box animations
        animSpeed:500, // Slide transition speed
        pauseTime:7000, // How long each slide will show
        startSlide:0, // Set starting Slide (0 index)
        directionNav:false, // Next & Prev navigation
        directionNavHide:true, // Only show on hover
        controlNav:true, // 1,2,3... navigation
        controlNavThumbs:false, // Use thumbnails for Control Nav
        controlNavThumbsFromRel:false, // Use image rel for thumbs
        controlNavThumbsSearch: '.jpg', // Replace this with...
        controlNavThumbsReplace: '_thumb.jpg', // ...this in thumb Image src
        keyboardNav:true, // Use left & right arrows
        pauseOnHover:false, // Stop animation while hovering
        manualAdvance:false, // Force manual transitions
        captionOpacity:0.8, // Universal caption opacity
        prevText: 'Prev', // Prev directionNav text
        nextText: 'Next', // Next directionNav text
        beforeChange: function(){}, // Triggers before a slide transition
        afterChange: function(){}, // Triggers after a slide transition
        slideshowEnd: function(){}, // Triggers after all slides have been shown
        lastSlide: function(){}, // Triggers when last slide is shown
        afterLoad: function(){} // Triggers when slider has loaded
    });





/*

  $("imge'apple").overlay({effect: 'apple'});

*/

});

function load_ckeditor(){
    CKEDITOR.replace( 'ckeditor',
      {
          uiColor : '#9AB8F3'
      });
};

function load_textarealimit(){
    $('#textareaLimit').limit('140','#charsLeft')
}

function iframe_sizing(){
  function autoResizeIFrame() {
    $('#iframe_product, #iframe_page').height(
      function() {
        return $(this).contents().find('body').height() + 20;
      }
    )
  }

  $('#iframe_product').contents().find('body').css(
    {"min-height": "100", "overflow" : "hidden"});

  setTimeout(autoResizeIFrame, 2000);
  setTimeout(autoResizeIFrame, 10000);

};
