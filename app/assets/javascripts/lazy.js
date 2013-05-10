$(document).ready(function() {
	$('.lazy').lazyload({
		failure_limit: 50,
    skip_invisible: false
	});
  $('.lazyLoad').each(function() {
    var original = $(this).attr('data-original');
    $(this).attr('src', original);
  })
  /*
  	$('.lazyLoad').lazyload({
  		event: 'load',
  		failure_limit: 50
  	});
  */
});