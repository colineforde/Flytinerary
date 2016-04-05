require 'json'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
url = URI("https://airport.api.aero/airport/?user_key=#{ENV["AIRPORT_API_KEY"]}")
response = Net::HTTP.get(url)
response = response[9..-2]
JSON.parse(response)["airports"].each do |airport|
	unless airport["name"] == nil
		Airport.create!(
			code: airport["code"],
			name: airport["name"],
			city: airport["city"],
			country: airport["country"],
			timezone: airport["timezone"],
			latitude: airport["lat"],
			longitude: airport["lng"]
			) 
	end
end

User.create(email: "c@gmail.com", password: "password")
Itinerary.create(name: "coline's trip", home_airport_id: 62, start_date: "2016-03-20", end_date: "2016-04-06",
user_id: 1)
Destination.create(itinerary_id: 1, airport_id: 105, order: 1)
Destination.create(itinerary_id: 1, airport_id: 635, order: 2)
Destination.create(itinerary_id: 1, airport_id: 2703, order: 3)
