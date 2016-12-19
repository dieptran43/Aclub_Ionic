$(document).ready(function() {
  if($('#map').length != 0) {
    var latDom = $("#venue_latitude");
    var lngDom = $("#venue_longitude");
    var address = $('#venue_full_address');
    function getLocation() {
      if(latDom.val() == '' || lngDom.val() == '') {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(showPosition);
        } else { 
            alert("Geolocation is not supported by this browser.");
        }
      } else {
        initMap();
      }
    }

    function showPosition(position) {
      var longitude = position.coords.longitude;
      var latitude = position.coords.latitude;
      latDom.val(latitude);
      lngDom.val(longitude);
      initMap();
    }

    function initMap() {
      latitude = parseFloat(latDom.val());
      longitude = parseFloat(lngDom.val());
      getAddress(latitude, longitude);
      var map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: latitude, lng: longitude},
        zoom: 15
      });

      var marker = new google.maps.Marker({
        position: {lat: latitude, lng: longitude},
        label: 'A',
        map: map
      });

      google.maps.event.addListener(map, 'click', function(event) {
        marker.setPosition(event.latLng)
        latitude = event.latLng.lat();
        longitude = event.latLng.lng();
        getAddress(latitude, longitude);
        latDom.val(latitude);
        lngDom.val(longitude);
      });
    }

    function getAddress(lat, lng) {
      $.ajax({
        url: 'http://maps.googleapis.com/maps/api/geocode/json',
        data: { latlng: lat + ',' + lng, sensor: true}
      }).done( function(data) {
        if(data.results.length > 0) {
          address.val(data.results[0].formatted_address);
        }
      }).error( function() {
          alert('Google Map getting error!')
      });
    }
    getLocation();
  }
});