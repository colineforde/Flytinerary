$(document).ready(function() {
	loadHomePageCarousel();
	ConfirmFlightDayListener();
	  	$('.destinations').select2({
  		maximumSelectionLength: 4,
	  	ajax: {
	  		url: "/airports/search",
	  		dataType: 'json',
	  		delay: 250,
	  		data: function(params){
	  			return {
	  				q: params.term,
	  				page: params.page
	  			};
	  		},
	  		processResults: function(data, params) {
	  			params.page = params.page || 1;
	  			data
	  			return {
	  				results: data.map(function(airport){ 
	  					return {id: airport.id, text: airport.name + ", " + airport.city}
	  				})
	  			}
	  		}
	  	}
 	});
 		$('.home-airport').select2({
	  	ajax: {
	  		url: "/airports/search",
	  		dataType: 'json',
	  		delay: 250,
	  		data: function(params){
	  			return {
	  				q: params.term,
	  				page: params.page
	  			};
	  		},
	  		processResults: function(data, params) {
	  			params.page = params.page || 1;
	  			data
	  			return {
	  				results: data.map(function(airport){ 
	  					return {id: airport.id, text: airport.name + ", " + airport.city}
	  				})
	  			}
	  		}
	  	}
 	});
 	$('.input-daterange').datepicker({
 		 dateFormat: "yy-mm-dd"
	});
	window.initMap = function() {
		if ($('.map').attr('id')){
        $.ajax({
        	url: '/itineraries/' + $('.map').attr('id') + '/flight_path'
        }).done(function(response){
        	var flightPlanCoordinates = response

        	var summed_coord = response.reduce(function (previousValue, currentValue) {
        		return {lat: previousValue.lat + currentValue.lat, lng:previousValue.lng + currentValue.lng}
        	})

        	var average_coord = {lat: summed_coord.lat / response.length, lng: summed_coord.lng / response.length }

        	var map = new google.maps.Map(document.getElementsByClassName('map')[0], {
         	 	zoom: 2,
         	 	center: average_coord,
         		mapTypeId: google.maps.MapTypeId.TERRAIN
        	});
	        var flightPath = new google.maps.Polyline({
	          path: flightPlanCoordinates,
	          geodesic: true,
	          strokeColor: 'purple',
	          strokeOpacity: 1.0,
	          strokeWeight: 2
	        });
	        response.forEach(function(latLong){
	        	var marker = new google.maps.Marker({
    			position: latLong,
   			 	map: map
 			 });

	        })

	        flightPath.setMap(map);
	        })
  		}
  	}
  	$(function() {
    $( "#sortable" ).sortable({
    	stop: function( event, ui ) {
    		var airports = $('.airport')
    		var listOfAirports = []
    		for (var i = 0; i < airports.length; i ++) {
    			listOfAirports.push({
    			 id: $(airports[i]).attr('id'),
    			 order: i + 1
    			})
    		}
    		$.ajax({
    			url: '/itineraries/' + $('.map').attr('id'),
    			method: 'put',
    			data: {
    				list_of_airports: listOfAirports,
    			}
    		}).done(function(){
    			window.initMap()
    		})    	
    	}
    });
    $( "#sortable" ).disableSelection();
  });
});

var ConfirmFlightDayListener = function() {
	$('.num_of_days').on('change', function(e){
		e.preventDefault();
		var data = { id: $(this).attr('id'), num_of_days: $(this).val() } 
		$.ajax({
			url:'/itineraries/' + $('.map').attr('id'),
			method: 'PUT',
			data: {airport: data}
		}).done(function(response){
			$('#days-remaining').html(response.days_remaining)
			if(response.days_remaining === 0) {
				$('#find-flights').prop("disabled", false)
			} else {
				$('#find-flights').prop("disabled", true)
			}
		})
	})
}

var loadHomePageCarousel = function(){
	$('#location-carousel').slick({
	  dots: false,
	  infinite: true,
	  speed: 900,
	  fade: true,
	  cssEase: 'linear', 
	  autoplay: true,
	  autoplaySpeed: 3000
	})
}
