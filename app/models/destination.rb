class Destination < ActiveRecord::Base
  # Remember to create a migration!
  	belongs_to :itinerary
	belongs_to :airport
end
