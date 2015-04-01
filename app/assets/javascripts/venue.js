console.log("diiirrrrrty");
var map;

//GOOGLE MAP JAVASCRIPT
function initialize() {
  var mapOptions = {
    zoom: 13,
    center: new google.maps.LatLng(40.7393080, -73.9894290)
  };
  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
};


function renderMap(latitude,longitude) {
  var mapOptions = {
    zoom: 13,
    center: new google.maps.Latlng(latitude,longitude)
  }
   map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);
}

$(function(){
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp' + '&signed_in=true&callback=initialize';
  document.body.appendChild(script);
  //

  $('#address-form').on('submit', function(e){
      e.preventDefault();
     var address = this.address.value
     geocodeAddress(address);

  })
})


var geocodeAddress = function(address) {
  $.ajax ({
      url: '/venues/near',
      dataType: 'json',
      data: {location: {address: address}},
      success: function(data){
        console.log(data);
     
      }
    })
}

// var parseFour = function(data) {
//   var base = data["response"]["groups"][0]["items"][i]["venue"]["name"]


//   return {
//     name: base[0]["venue"]["name"]
//   }
// }

// STEP 1 = GEOCODE address on submit from the form
// STEP 2 = make ajax call to venue#near to grab a list of restaurants from my own database
// STEP 3 = ON SUCCESS, make ajax call to FourSQ to get a list of restaurants near the input location
// STEP 4 = upon success, compare the list of venues from FourSQ and my own database, IF IT MATCHES, render somehow. 

//stuff FourSQ needs:
// var foursquareUrl = "https://api.foursquare.com/v2/venues/search";

// var version = "&v=20150223&ll";
// var restaurant = "&query=restaurants"
// // var query = clientID + clientSecret + version 

// //stuff Google geocoding needs: 
// var googleUrl = "https://maps.googleapis.com/maps/api/geocode/json?address="



// var everythingElse = function(address) {

//     $.ajax ({
//       url: googleUrl + origin + "&key=",
//       dataType: 'json',
//       success: function(data){
//         //ajax call to my own database
//         $.ajax ({
//           url: '/venues/near',
//           data: data["results"][0]["geometry"]["location"],
//           dataType: 'json',
//           success: function(data){
//             // ajax call to foursquare
//             $.ajax({
//               // is data the lat lng? 
//               url: foursquareUrl + query + data + "&query=restaurants",
//               dataType: 'json',
//               success: function(data){

       
//           }

//         })
//       }

//     })
// })
// }

// var getFourSquareResults = function(local_venues) {
//   local_venues.forEach(function(venue){
//     //need to get local_venues lat and long
//     latitude = 
//     longitude = 

//      var baseURL = "https://api.foursquare.com/v2/venues/search";
//       var clientID = "?client_id=#{ENV['FOURSQUARE_CLIENT_ID']";
//       var clientSecret = "&client_secret=#{ENV['FOURSQUARE_CLIENT_SECRET']";
//       var version = "&v=20150223";
//       var latlng = "&ll="
//       var query = clientID + clientSecret + version + latlng 

//     $.ajax({
//         getResults(query);
//         url: baseUrl + query
//         type: 'GET',
//         dataType: 'json',
//         success: function (data) {



//   }

//   )}

// var baseURL = "https://api.foursquare.com/v2/venues/search";
// var clientID = "?client_id=#{ENV['FOURSQUARE_CLIENT_ID']";
// var clientSecret = "&client_secret=#{ENV['FOURSQUARE_CLIENT_SECRET']";
// var version = "&v=20150223";
// var latlng = "&ll="
// var query = clientID + clientSecret + version + latlng 
//   getResults(query);



// function getResults (query) {
//   $.ajax({
//   url: baseURL + query,
//   dataType: 'json',
//   success: function(data) {
//     console.log(data)
//     renderResults( data );
//     // logResults( data );
//     }
//   });
// };





// var myLatlng = new google.maps.LatLng(40.7393080, -73.9894290);

// var marker = new google.maps.Marker({
//     position: myLatlng,
//     title:"Hello World!"
// });

// // To add the marker to the map, call setMap();
// marker.setMap(map);


