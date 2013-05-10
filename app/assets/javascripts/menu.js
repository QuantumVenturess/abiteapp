$(document).ready(function() {
  var body = $('body');
  var footer = $('.footer');
  var panel = $('.menu_panel');
  $('.menu').click(function() {
    body.addClass('grayBackground');
    footer.hide();
    panel.show();
  });
  $('.menu_panel a').click(function (){
    window.location = $(this).attr('href');
  });
  $('.menu_panel .back').click(function() {
    body.removeClass('grayBackground');
    footer.show();
    panel.hide();
  });
});