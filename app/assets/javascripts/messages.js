$(document).ready(function() {
  var container = $('.messageContainer');
  // Click compose shows message container and message form
  $('.compose').click(function() {
    container.show();
    $('.messageContainer textarea').focus();
  });
  // Cancel message hides message container
  $('.cancelMessage, .messageContainer button').click(function() {
    container.hide();
  });
});