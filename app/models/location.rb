class Location < ActiveRecord::Base
	belongs_to :list
	validates :address, :presence => true
	validates :lat, :presence => true
	validates :lng, :presence => true

end
