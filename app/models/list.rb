class List < ActiveRecord::Base

	#delete locations and favorites associated with a List when the list is deleted by the user
	before_destroy { |record| Location.destroy_all "list_id = #{record.id}" }
  	before_destroy { |record| Favorite.destroy_all "list_id = #{record.id}" }

	has_many :locations
	belongs_to :user
	has_many :favorites
end
