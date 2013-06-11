$(document).ready(function() {
  var menu = $('.menuView');
  $('.menu').click(function() {
    menu.show();
  });
  $('.menu_panel a').click(function (){
    window.location = $(this).attr('href');
  });
  $('.menu_panel .back').click(function() {
    menu.hide();
  });
});