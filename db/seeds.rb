# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#array of hashes for seed data
lists = [{:name => "Flushing", :description => "Places to eat in Flushing", :owner =>"a@a.com"},{:name => "Chicago", :description => 'Downtown Tour', :owner => "b@b.com"}]
locations = [{:name => 'Flushing - Main St [7] MTA stop', :lat => 40.759671, :lng => -73.830203, :address => '39-46 Main Street, Flushing, Queens, NY, United States'},
{:name => 'Target', :lat => 40.757815, :lng => -73.834686, :address => '4024 College Point Blvd Flushing, NY 11354'}]
users = [{:name => "a", :email => "a@a.com", :password => "a"},{:name => "b", :email => "b@b.com", :password => "b"}]
User.destroy_all
List.destroy_all
Location.destroy_all

users.each do |user|
	u = User.new
	u.name = user[:name]
	u.email = user[:email]
	u.password = user[:password]
	u.password_confirmation = user[:password]
	u.save
end

lists.each do |list|
	l = List.new
	l.name = list[:name] #careful! list is a hash, whereas l is an object
	l.description = list[:description]
	u = User.find_by(:email => list[:owner])
	l.user_id = u.id
	l.save
end

list = List.all
locations.each do |location|
	loc = Location.new
	loc.list_id = list[0][:id]
	loc.name = location[:name] #careful! location is a hash, whereas loc is an object
	loc.lat = location[:lat]
	loc.lng = location[:lng]
	loc.address = location[:address]
	loc.save
end

locations = [{:name => 'Merchandise Mart', :lat => 40.759671, :lng => -73.830203, :address => 'Wells and Kinzie, Chicago IL'}]
locations.each do |location|
	loc = Location.new
	loc.list_id = list[1][:id]
	loc.name = location[:name] #careful! location is a hash, whereas loc is an object
	loc.lat = location[:lat]
	loc.lng = location[:lng]
	loc.address = location[:address]
	loc.save
end

