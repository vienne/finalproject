
class VenuesController < ApplicationController

include HTTParty
include JSON

	def index
		@violation = Violation.order("RANDOM()").first

		respond_to do |format|
      format.html { render :index }
    end
	end

	def near
		# lat, lng = 40.7393080, -73.9894290
		# lat, lng = near_params.lat, near_params.lng
		@violation = Violation.order("RANDOM()").first 
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


		@venues = Venue.where(latitude: (origin[:lat] - (1/200.00)..origin[:lat] + (1/200.00)), longitude: (origin[:lng] - (1/200.00)..origin[:lng] + (1/200.00)))



		matches = []

		@venues.each do |venue|
			foursquare_array.each do |four|
				if venue[:name] == four[:name]
					matches << {venue: venue, foursquare: four, violations: venue.violations.uniq}
				end
			end
		end


		respond_to do |format|
      format.html { render :index }
      format.json { render json: matches}
    end

	end

	private

	def near_params
		@near_params ||= params.require(:location).permit(:address)
	end

end