require 'bcrypt'

class User < ActiveRecord::Base
	validates :password, :email, presence: true
	has_many :itineraries
	def password 
  	@password ||= BCrypt::Password.new(encrypted_password)
  	end

  	def password=(new_password)
  		@password = BCrypt::Password.create(new_password)
  		self.encrypted_password = @password
  	end

  	def authenticate(password)
  		self.password == password
  	end
  # Remember to create a migration!
end
