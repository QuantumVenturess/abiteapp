$(document).ready(function() {
  $(window).scroll(function() {
    var next = $('.pagination .next a').attr('href');
    if (next && $(window).scrollTop() > 
        $(document).height() - ($(window).height() + 500)) {
      $('.pagination').remove();
      $('.spinner').show();
      $.ajax({
        dataType: 'script',
        type: 'GET',
        url: next,
        success: function(response) {
          $('.spinner').hide();
        }
      });
    };
  });
});