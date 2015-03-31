# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require './app/models/venue.rb'

Rails.application.load_tasks

ActiveRecord::Base.establish_connection(
    :adapter  => "postgresql",
    :database => "final_project_development"
)


# base url = https://api.foursquare.com/v2/venues/search?

# client_id = FLSSZP5XK1MWVQQKNULMCIMI3XKSNROMWNRFFENSYP3GD51D

# &client_secret = TMRJQMZS3LGSF3YHY3ZGP5UBXMAGWOMLE4VQRF0M2HH3RDFT

# &v = 20150223

# &ll = 40.7211430,-73.9838570

namespace :db do
	desc "get_geocode"
	task :get_geocode do
		#and address is not empty
		venues = Venue.where(longitude: nil)

		venues.each do |venue|
			geo=Geokit::Geocoders::MultiGeocoder.geocode (venue.address)
	
			if geo.success
				venue.latitude = geo.lat
				venue.longitude = geo.lng
				venue.save!
			else
				venue.delete
			end
		end
	end
	desc "fix_address"
	task :fix_address do
		venues = Venue.where(address: nil)

		venues.each do |venue|
			venue.address = "#{venue.building} #{venue.street}, #{venue.zip}"
			venue.save!
		end
	end
	
end