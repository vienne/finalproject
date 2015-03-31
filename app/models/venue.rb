class Venue < ActiveRecord::Base
	# acts_as_mappable :default_units => :miles,
	#                  :default_formula => :sphere,
	#                  :distance_field_name => :distance,
	#                  :lat_column_name => :latitude,
	#                  :lng_column_name => :longitude,
	#                  :auto_geocode=>{:field=>:address}

	has_many :violations, through: :venue_violations
	has_many :venue_violations

	

	def geocode_location(address)
		geo=Geokit::Geocoders::MultiGeocoder.geocode(address)
    errors.add(:address, "Could not Geocode address") if !geo.success
	end

end
