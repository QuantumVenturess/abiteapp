$(document).ready(function() {
  $('.markComplete div').click(function() {
    var url = $(this).attr('href');
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(postion) {
        var lat = postion.coords.latitude;
        var lon = postion.coords.longitude;
        $.ajax({
          data: {
            lat: lat,
            lon: lon
          },
          dataType: 'script',
          type: 'GET',
          url: url
        });
      });
    }
    else {
      alert('You must enable GPS to mark complete');
    }
  });
});