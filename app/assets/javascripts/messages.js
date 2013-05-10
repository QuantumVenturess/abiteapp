$(document).ready(function() {
  var messageContainer = $('.messageContainer');
  $('.messageFormHolder textarea').click(function() {
    $('html').css('overflow-y', 'hidden');
    $('body').css('overflow-y', 'hidden');
    messageContainer.show();
  });
  $('.messageForm .cancelForm').click(function() {
    $('html').css('overflow-y', 'visible');
    $('body').css('overflow-y', 'visible');
    messageContainer.hide();
    $('html, body').animate({ scrollTop: $(document).height() + 1000 }, 0);
  });
});