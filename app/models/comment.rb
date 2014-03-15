class Comment < ActiveRecord::Base
	before_create :checktext
	belongs_to :user
	belongs_to :location

	def checktext
		if self.text.blank?
			return false
		end
	end
end
