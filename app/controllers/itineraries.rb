require 'pry'

get '/itineraries' do 
end

get '/itineraries/new' do 
	erb :'itineraries/new'
end


get '/itineraries/sample/tickets' do 
	@available_flights=JSON.parse(File.read("sample.json"))
	erb :'itineraries/tickets'
end


get '/itineraries/:id/tickets' do 
	itinerary = Itinerary.find(params[:id])
	@available_flights=itinerary.available_flights
	erb :'itineraries/tickets'
end

get '/itineraries/:id' do
	@itinerary = Itinerary.find(params[:id])
	erb :'itineraries/show'
end

post '/itineraries' do 
	itinerary = Itinerary.create(
			name: params[:itinerary_name],
			home_airport_id: params[:home_airport_id],
			user_id: session[:user_id],
			start_date: params[:start_date],
			end_date: params[:end_date]
		)
		params[:airport_ids].each do |airport_id|
			Destination.create(
			itinerary_id: itinerary.id,
			 airport_id: airport_id
			)
		end
		redirect "/itineraries/#{itinerary.id}"
end

get '/itineraries/:id/flight_path' do 
	@itinerary = Itinerary.find(params[:id])
	path = @itinerary.destinations.sort_by(&:order).map do |destination|
		{lat: destination.airport.latitude, lng: destination.airport.longitude}
	end
	path.unshift({lat: @itinerary.home_airport.latitude, lng: @itinerary.home_airport.longitude})
	path.push({lat: @itinerary.home_airport.latitude, lng: @itinerary.home_airport.longitude})
	json path
end

put '/itineraries/:id' do 
	itinerary = Itinerary.find(params[:id])
	if params[:list_of_airports]
		params[:list_of_airports].each do |key, destination_params|
			destination = Destination.find_by(airport_id: destination_params[:id], itinerary_id: itinerary.id)
			destination.update_attributes(order: destination_params[:order])
		end
	end
	if params[:airport]
		destination = Destination.find_by(airport_id: params[:airport][:id], itinerary_id: itinerary.id)
		destination.num_of_days = params[:airport][:num_of_days]
		destination.save
	end
	json({days_remaining: itinerary.num_of_days_remaining})
end
