class Itinerary < ActiveRecord::Base
  # Remember to create a migration!
  has_many :destinations
	has_many :airports, through: :destinations
	belongs_to :user 
	belongs_to :home_airport, { :class_name => "Airport", :foreign_key => :home_airport_id}

	def waypoints
		airports.map do |airport|
			"#{airport.latitude},#{airport.longitude}"
		end.join("|")
	end

	def trip_length
		(end_date - start_date).to_i 
	end

	def num_of_days_remaining

		trip_length - (destinations.map(&:num_of_days).compact.reduce(:+) || 0)
	end

	def available_flights
		uri = URI.parse("https://www.googleapis.com")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		request = Net::HTTP::Post.new("/qpxExpress/v1/trips/search?key=#{ENV["FLIGHT_SEARCH_KEY"]}")
		request.add_field('Content-Type', 'application/json')
		destinations = self.destinations.sort_by(&:order)
		departures = destinations.map(&:airport)
		departures.unshift(home_airport)
		arrivals = destinations.map(&:airport)
		arrivals.push(home_airport)
		starting_leg = start_date
		departure_dates = destinations.map do |destination|
			starting_leg += destination.num_of_days
		end
		departure_dates.unshift(start_date)

		slices = departures.zip(arrivals, departure_dates).map do |departure, arrival, departure_date|
			{
				origin: departure.code,
				destination: arrival.code,
				date: departure_date
			}
		end

		request.body = {
			request:{
				passengers:{
					adultCount: '1'
				},
				solutions: '4',
				slice: slices
			}
		}.to_json
		JSON.parse(http.request(request).body)
	end
end
