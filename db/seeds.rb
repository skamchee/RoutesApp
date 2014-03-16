# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#array of hashes for seed data
lists = [
	{:name => "Flushing", :description => "Places to eat in Flushing, NY", :owner =>"a@a.com"},
	{:name => "Chicago", :description => 'Downtown Tour', :owner => "b@b.com"}]

locations = [
	{name: 'Flushing - Main St [7] MTA stop', :lat => 40.759671, :lng => -73.830203, :address => '39-46 Main Street, Flushing, Queens, NY, United States', description: 'Start your journey here at the train station'},
	{name: 'Biang!', lat: 40.757789, lng: -73.82951, address: '41-10 Main St, Queens, NY, United States', description: 'Biang! is a scion of the well-known Xi\'an Famous Foods brand, which is a small chain of specialty Chinese restaurants that specialize in authentic Chinese cuisine from the western Chinese city of Xi\'an. While Xi\'an Famous Foods is great for fast and casual dining, we wanted to present our food in a chic venue with full waiter-service, and that is how Biang! came to be.'},
	{name:'White Bear', lat: 40.758764, lng: -73.831664, address: '135-02 Roosevelt Ave Ste 5 Flushing, NY 11354', description: 'Manhattan\'s Chinatown has its share of dumplings: potstickers aplenty, Shanghainese xiao long bao, some wontons here and there. But if you want real dumpling diversity, and an overall upgrade in quality, you have to hop the 7 train to Flushing, the dumpling lover\'s mecca.'},
	{name:'New World Mall Food Court', lat: 40.759357, lng: -73.829222, address:'136-20 Roosevelt Avenue, Flushing, NY, United States', description: 'The mall features an exciting food court in the lower level with over 32 different American and Ethnic food vendors. With a wide range of foods from different areas of North and SouthEast Asia; stalls offer Malaysian, Thai, Vietnamese, Chinese, Korean and Japanese foods including bento boxes and sushi, ramen noodles, and assorted Asian desserts. In addition, the food court offers a great choice of fast foods.'}]

users = [
	{:name => "a", :email => "a@a.com", :password => "a"},
	{:name => "b", :email => "b@b.com", :password => "b"}]

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
	loc.description = location[:description]
	loc.save
end

locations = [
	{name: 'Merchandise Mart', lat: 41.88837, lng: -87.635364, address: '222 W Merchandise Mart Plaza, Chicago, IL 60654, United States', description: 'The Merchandise Mart is a commercial building located in the Near North Side of Chicago, Illinois, United States. When it opened in 1930 it was the largest building in the world, with 4,000,000 square feet of floor space.'},
	{name: 'John Hancock Center', lat: 41.898759, lng: -87.622916, address: '875 N Michigan Ave, Chicago, IL 60611', description: 'The John Hancock Center, at 875 North Michigan Avenue in the Streeterville area of Chicago, Illinois, United States, is a 100-story, 1,127-foot (344 m) tall skyscraper, constructed under the supervision of Skidmore, Owings and Merrill'},
	{name: 'Art Institute', lat: 41.879585, lng: -87.623712, address: '111 S Michigan Ave, Chicago, IL 60603', description: 'The Art Institute of Chicago is an encyclopedic art museum located in Chicago\'s Grant Park. It features a collection of Impressionist and Post-Impressionist art in its permanent collection.'}]
locations.each do |location|
	loc = Location.new
	loc.list_id = list[1][:id]
	loc.name = location[:name] #careful! location is a hash, whereas loc is an object
	loc.lat = location[:lat]
	loc.lng = location[:lng]
	loc.address = location[:address]
	loc.description = location[:description]
	loc.save
end

