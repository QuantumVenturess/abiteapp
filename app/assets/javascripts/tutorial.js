$(document).ready(function() {
  var start = $('.tutorial .start');
  var join  = $('.tutorial .join');
  var ready = $('.tutorial .ready');
  var duration = 200;
  $('.tutorial .start .next').click(function() {
    start.hide('slide', { direction: 'left' }, duration);
    join.show('slide', { direction: 'right' }, duration);
  });
  $('.tutorial .join .next').click(function() {
    join.hide('slide', { direction: 'left' }, duration);
    ready.show('slide', { direction: 'right' }, duration);
  });
  $('.tutorial .join .prev').click(function() {
    join.hide('slide', { direction: 'right' }, duration);
    start.show('slide', { direction: 'left' }, duration);
  });
  $('.tutorial .ready .next').click(function() {
    $('.tutorial').fadeOut(duration);
    $.ajax({
      dataType: 'script',
      type: 'GET',
      url: '/read-tutorial'
    });
  });
  $('.tutorial .ready .prev').click(function() {
    ready.hide('slide', { direction: 'right' }, duration);
    join.show('slide', { direction: 'left' }, duration);
  });
});