class Location < ActiveRecord::Base

	before_destroy { |record| Comment.destroy_all "location_id = #{record.id}" }

	belongs_to :list
	validates :address, :presence => true
	validates :lat, :presence => true
	validates :lng, :presence => true
	has_many :comments
end
