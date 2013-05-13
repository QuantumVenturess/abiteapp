$(document).ready(function() {
  /*
  var flash = $('.flash');
  if (flash.length > 0) {
    flash.delay(3000).slideUp(100);
  };
  */
  $('.flash').click(function() {
    $(this).slideUp(100);
  });
});