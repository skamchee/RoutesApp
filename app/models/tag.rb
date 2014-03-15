class Tag < ActiveRecord::Base
	before_create :checktext
	belongs_to :list

	#prevents a save if the tag is blank
	def checktext
		if self.text.blank?
			return false
		end
	end
end
