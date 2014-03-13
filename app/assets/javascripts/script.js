//for directions
var directionsDisplay;
var directionsService = new google.maps.DirectionsService();
var stops = [];

//rendering map
var geocoder;
var map;
var map_canvas;
var bounds;
var markers = [];
var counter=0;
var alphabet = new Array('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z');

/**needed for displaying the map*/
function initialize() {
    geocoder = new google.maps.Geocoder();
    console.log("first");
    var myLatLng = new google.maps.LatLng(0,0);
    map_canvas = document.getElementById("mapcanvas");
    map_canvas.style.display="none"/* don't display it until markers are added*/
    var map_options = {
        center: myLatLng,
        zoom: 16,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    map = new google.maps.Map(map_canvas, map_options);
    //console.log(map);

    // This is needed to set the zoom after fitbounds, because fitbounds runs asynchronously
    google.maps.event.addListener(map, 'zoom_changed', function() {
        zoomChangeBoundsListener = 
            google.maps.event.addListener(map, 'bounds_changed', function(event) {
                if (map.getZoom() > 15 && map.initialZoom == true) {
                    // Change max/min zoom here
                    map.setZoom(15);
                    map.initialZoom = false;
                }
            google.maps.event.removeListener(zoomChangeBoundsListener);
        });
    });
    map.initialZoom = true;
}


function initDirections(){ 
    directionsDisplay = new google.maps.DirectionsRenderer();
    directionsDisplay.setMap(map);    
}

//convert an address to LatLng
//put a marker where the LatLng point is
/*function codeAddress(address2,info,order){
    geocoder.geocode( {'address': address2}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
        addMarker(results[0].geometry.location,info,order);
        map.fitBounds(bounds);
        if(map.getZoom()>16)
        map.setZoom(16);//keep the zoom at reasonable level when markers are all set in the same small area
    } else {
            alert("Geocode was not successful for the following reason: " + status);
    }
    });
}*/

function codeLatLng(lat,lng,info,order){
    map_canvas.style.display = "block";
    var latlng = new google.maps.LatLng(lat,lng);
    addMarker(latlng,info,order);
    map.fitBounds(bounds);
}

/**display a marker on the map*/
function addMarker(latlng,info,order){
    
   if(counter==0){
        bounds = new google.maps.LatLngBounds(latlng,latlng); //LatLngBounds takes two LatLng objects as input
        counter +=1;
    }else{
        bounds.extend(latlng);
    }
    var marker = new google.maps.Marker({
        map: map,
        position: latlng,
        icon: '../assets/marker'+alphabet[order]+'.png'
    });    
    markers.push(marker);

    var infowindow = new google.maps.InfoWindow({
    content: info
    });
        google.maps.event.addListener(marker, 'click', function(){
        infowindow.open(map,marker);
    });
}

/**Puts all markers in the markers array on map specified by the map parameter*/
function setAllMap(map) {
    for (var i = 0; i < markers.length; i++) {
    markers[i].setMap(map);
    }
}

/** Removes the markers from the map, but keeps them in the markers array.*/
function clearMarkers() {
    setAllMap(null);
}

/**Puts to the map all markers in the markers array*/
function showMarkers() {
    setAllMap(map);
}
 
//add a waypoint to be used in calculating directions
function addStops(lat,lng){    
    stops.push({
    location:new google.maps.LatLng(lat,lng),
    stopover:true});   
}

/**package a request for direction*/
//google limits usage to 8 waypoints (23 for business users)
//for a total of 10 total points
function calcRoute(){
    var request = {
    origin: stops[0].location,
    destination: stops[stops.length-1].location,
    waypoints: stops.slice(1,stops.length-1),//slice includes the first element specified, but not the last one
    //optimizeWaypoints: true,
    travelMode: google.maps.TravelMode.WALKING
    };
    drawRoute(request);
}

/**get a route.*/
function drawRoute(request){
   directionsService.route(request, function(response,status){
       if(status==google.maps.DirectionsStatus.OK){
        //directionsDisplay.setDirections(response);
        drawRoutePolyline(response);
       }
    });
}

/**decode a polyline path to lat lngs*/
function drawRoutePolyline(response){
    var arrayLatLng = google.maps.geometry.encoding.decodePath(response.routes[0].overview_polyline.points);//response.routes[0].legs[0].steps[0].polyline.points);
    var num_points = arrayLatLng.length;

    var polyOptions = {
    strokeColor: '#0000CC',
    strokeOpacity: 4.0,
    strokeWeight: 3
    };
    poly = new google.maps.Polyline(polyOptions);
    poly.setMap(map);
    var path = poly.getPath();

    for(var i=0; i<num_points; i++)
    path.push(arrayLatLng[i]);
}

/*=====AUTOCOMPLETE CODE ====*/
/**
    Handles autocomplete of user input
    Geocodes user input to a lat lng. The only point geocoding occurs in the app is when a user adds or deletes a locationx
*/
var autocomplete;
var componentForm = {
    lat: 'short_name',
    lng: 'short_name'
};

function initac(){
    autocomplete = new google.maps.places.Autocomplete(
    document.getElementById('autocomplete'));
    //when the user selects a location from the dropdown, call fillinAddress();
    google.maps.event.addListener(autocomplete, 'place_changed', function(){mapAddress();});
}

// Bias the autocomplete object to the user's geographical location,
// as supplied by the browser's 'navigator.geolocation' object.
function geolocate() {
    if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
        var geolocation = new google.maps.LatLng(
        position.coords.latitude, position.coords.longitude);
        autocomplete.setBounds(new google.maps.LatLngBounds(geolocation,
                                geolocation));
    });
    }
}

/**Get the lat lng from the autocomplete object. Display the business information as well as the map
*/
function mapAddress() {
  // Get the place details from the autocomplete object.
    var place = autocomplete.getPlace();
    if(!place.geometry){
    console.log("no geometry returned");
    return; 
    }
    //clear out the form
//    for (var component in componentForm) {
//  document.getElementById(component).value = '';
//  document.getElementById(component).disabled = false;
  //  }

    var lat = place.geometry.location.lat();//place.geometry.location.d;
    var lng = place.geometry.location.lng();//place.geometry.location.e;
    document.getElementById("lat").value = lat;
    document.getElementById("lng").value = lng; 
}
