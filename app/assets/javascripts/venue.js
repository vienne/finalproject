console.log("diiirrrrrty");
var map;
var infowindow;
var marker;
var markers = [];

//GOOGLE MAP JAVASCRIPT
function initialize () {
  var myLatLng = new google.maps.LatLng(40.7393080, -73.9894290);
  
  var mapOptions = {
    zoom: 13,
    center: myLatLng
  };
  
  map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
  infowindow = new google.maps.InfoWindow();

  var styles = [
    {
      "featureType": "all",
      "elementType": "geometry",
      "stylers": [
          {
              "visibility": "off"
          }
      ]
    },
    {
      "featureType": "all",
      "elementType": "labels",
      "stylers": [
          {
              "visibility": "off"
          }
      ]
    },
    {
      "featureType": "landscape",
      "elementType": "all",
      "stylers": [
          {
              "color": "#f2f2f2"
          },
          {
              "visibility": "on"
          }
      ]
    },
    {
      "featureType": "poi.business",
      "elementType": "labels.text",
      "stylers": [
          {
              "visibility": "off"
          }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
          {
              "visibility": "on"
          },
          {
              "color": "#000000"
          }
      ]
    }
  ]
  
  var styledMap = new google.maps.StyledMapType(styles,
    {name: "Styled Map"});

  map.mapTypes.set('map_style', styledMap);
  map.setMapTypeId('map_style');
}

function renderMap(latitude, longitude) {
  var mapOptions = {
    zoom: 16,
    center: new google.maps.Latlng(latitude,longitude)
  };

  map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
}

var geocodeAddress = function (address) {
  $.ajax ({
    url: '/venues/near',
    dataType: 'json',
    data: {
      location: {
        address: address
      }
    },
    success: function(data) {
       deleteMarkers();
  
      if (data.length === 0){
        $("#error").slideToggle();
      } else {
        createMarkers(data);
      }

    }  
  })
}

function setAllMap(map) {
  for (var i = 0; i < markers.length; i++) {
    markers[i].setMap(map);
  }
}

function clearMarkers() {
  setAllMap(null);
}

var deleteMarkers = function () {
  clearMarkers();
  markers = [];
}

var currentViolations = {};

var createMarkers = function (data) {
  data.forEach(function(data){
    var venueViolations = [];
      data["violations"].forEach(function(violation){
        venueViolations.push(violation)
      })

    currentViolations[data["venue"]["camis"]] = venueViolations;

    var number = venueViolations.length;

    var lat = data["venue"]["latitude"];
    var lng = data["venue"]["longitude"];
    var pos = new google.maps.LatLng(lat, lng);
    marker = new google.maps.Marker({
      position: pos,
      map: map,
      name: data["venue"]["name"],
      url: data["foursquare"]["url"],
      cuisine: data["venue"]["cuisine"],
      address: data["venue"]["address"],
      grade: data["venue"]["grade"],
      checkins: data["foursquare"]["checkins"],
      violations: number
    });

    var content = "Name: " + marker.name + "</br>" + "URL: " + '<a href="'+ marker.url +'">visit the website</a>' + "</br>" + "Cuisine: " + marker.cuisine + "</br>" + "Address: " + marker.address + "</br>" + "Grade: " + marker.grade + "</br>" + "FourSquare Checkins: " + marker.checkins + "</br>" + "# of Violations: " + '<a href="#" class="violation-number" data-camis="' + data["venue"]["camis"] + '">'+ marker.violations + '</a>';
       
    google.maps.event.addListener(marker, 'click', function(){
      infowindow.setContent(content);
      infowindow.open(map, this);
    })
    markers.push(marker);
  });
  
  var centerLat = data[0]["venue"]["latitude"];
  var centerLng = data[0]["venue"]["longitude"];
  
  // setCenter(latlng:)
  map.setZoom(16);
  map.setCenter(new google.maps.LatLng(centerLat, centerLng));

};


function renderInfo(map,ctx){
  
  infowindow.setContent('blah');
  infowindow.open(map, ctx);
}
// FUNCTIONS4LYFE

$(function () {
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp' + '&signed_in=true&callback=initialize';
  document.body.appendChild(script);
  
  // jQuery that needs to GRAB SHIT GOES HERE

  $('#address-form').on('submit', function(e){
      e.preventDefault();
     var address = this.address.value
     geocodeAddress(address);
  });

  // $('#close-error').on('click', function() {
  //   $("#error").slideToggle();
  // });

  
////
  $('body').on('click', '.violation-number', function() { 
    $('#violation-div').slideToggle();  

    violationList =  currentViolations[$(this).data('camis')];

    var $div = $('#violation-div');
    $div.empty();
    var $violationsUl = $('<ul class="violationsUl">violations from within the last year: </ul>');
    $div.append($violationsUl);
    
    violationList.forEach(function(violation){
      var eachViolation = violation["violation_description"];
      $violationsUl.append('<li class="violationsLi">' + eachViolation + '</li>')
    })
    $closeDiv = $('<div></div>', {id:"close-violation"}).text("click me and i shall close this here div").appendTo($div)
    $closeDiv.on('click', function() {
      $("#violation-div").slideToggle();
    })
    
 });

})  






