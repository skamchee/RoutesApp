class User < ActiveRecord::Base
	has_many :lists	#adds methods to access lists from the User object
	has_secure_password #adds authenticate method which uses bcrypt (make sure to have bcrypt in Gemfile)
	validates :name, uniqueness: true
	validates :email, uniqueness: true
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

	has_many :favorites
	has_many :comments
end
