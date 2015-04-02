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
     //  if (data == undefined){
     // alert("please go fuck thyself");}
      deleteMarkers();
      createMarkers(data);
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



var createMarkers = function (data) {
  data.forEach(function(data){

    var lat = data["venue"]["latitude"];
    var lng = data["venue"]["longitude"];

    var pos = new google.maps.LatLng(lat, lng);
    
    marker = new google.maps.Marker({
      position: pos,
      map: map,
      name: data["venue"]["name"],
      cuisine: data["venue"]["cuisine"],
      address: data["venue"]["address"],
      grade: data["venue"]["grade"]

    });
    var content = "Name: " + marker.name + "</br>" + "Cuisine: " + marker.cuisine + "</br>" + "Address: " + marker.address + "</br>" + "Grade: " + marker.grade;
    google.maps.event.addListener(marker, 'click', function(){
      infowindow.setContent(content);
      infowindow.open(map, this);
    })
 
   
    markers.push(marker);

  });


  var centerLat = data[0]["venue"]["latitude"];
  var centerLng = data[0]["venue"]["longitude"];
  

  // setCenter(latlng:)
  map.setZoom(15);
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
  })
})






