class List < ActiveRecord::Base
	has_many :locations, :dependent => :destroy
	belongs_to :user

	has_many :favorites
end
