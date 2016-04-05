class Airport < ActiveRecord::Base
	has_many :destionations
	has_many :itineraries, through: :destinations

	def coordinates
		"#{latitude},#{longitude}"
	end
  # Remember to create a migration!
end
