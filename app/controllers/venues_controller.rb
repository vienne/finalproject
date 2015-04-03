
class VenuesController < ApplicationController

include HTTParty
include JSON

	def index
		origin_address = Geokit::Geocoders::MultiGeocoder.geocode(params[:origin])
		origin_lng = origin_address.lng || -73.9894290
		origin_lat = origin_address.lat || 40.7393080

		@venues = Venue.where(latitude: (origin_lat - (1/345.00)..origin_lat + (1/345.00)), longitude: (origin_lng - (1/345.00)..origin_lng + (1/345.00)))

		@violations = Violation.all

		respond_to do |format|
      format.html { render :index }
      format.json { render json: @venues }
    end
	end

	def near
		# lat, lng = 40.7393080, -73.9894290
		# lat, lng = near_params.lat, near_params.lng
		@violations = Violation.all 
		# Geocoding the Address
		origin_address = Geokit::Geocoders::MultiGeocoder.geocode(params[:location][:address])
		
		origin = {lat: origin_address.lat, lng: origin_address.lng}
		
		# Calling 4^2 API for 30 restaurants close to address
		results = HTTParty.get("https://api.foursquare.com/v2/venues/explore?client_id=#{ENV["FOURSQUARE_CLIENT_ID"]}&client_secret=#{ENV["FOURSQUARE_CLIENT_SECRET"]}&v=20150223&ll=#{origin[:lat]},#{origin[:lng]}&section=food")
		
		result_array = results["response"]["groups"][0]["items"]

		# Parsing through 4^2 and creating an array of hashes
		foursquare_array = []
		for index in (0...result_array.length)
			foursquare_array << {
				name: result_array[index]["venue"]["name"].upcase,
				lat: result_array[index]["venue"]["location"]["lat"],
				lng: result_array[index]["venue"]["location"]["lng"],
				checkins: result_array[index]["venue"]["stats"]["checkinsCount"],
				url: result_array[index]["venue"]["url"],
				rating:result_array[index]["venue"]["rating"],
				hours:result_array[index]["venue"]["hours"]
			}

		end

		# Finding restaurants within 4 blocks of address from my db
		# @venues = Venue.where(latitude: (origin[:lat] - (1/345.00)..origin[:lat] + (1/345.00)), longitude: (origin[:lng] - (1/345.00)..origin[:lng] + (1/345.00)))


		@venues = Venue.where(latitude: (origin[:lat] - (1/200.00)..origin[:lat] + (1/200.00)), longitude: (origin[:lng] - (1/200.00)..origin[:lng] + (1/200.00)))

		# Finding matches between 4^2 query and my db
		
		# @venues.each do |venue|
		# 	venue << venue.violations
		# end

		matches = []

		@venues.each do |venue|
			foursquare_array.each do |four|
				if venue[:name] == four[:name]
					matches << {venue: venue, foursquare: four, violations: venue.violations}
				end
			end
		end

		# venues = Venue.all
		# returned = []
		# venues.each do |venue|
		# 	venue.venue_violations.each do |violation|
		# 		if violation.violation_id == 2
		# 			returned << venue
		# 		end
		# 	end
		# end

		respond_to do |format|
      format.html { render :index }
      format.json { render json: matches}
    end
		# render json: @venues
	end

	private

	def near_params
		@near_params ||= params.require(:location).permit(:address)
	end

end