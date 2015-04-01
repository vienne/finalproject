

	class FoursquareApi

		def four_squared(lat,lng)

			HTTParty.get('https://api.foursquare.com/v2/venues/search?client_id=#{ENV["FOURSQURE_CLIENT_ID"]}&client_secret=#{ENV[FOURSQURE_CLIENT_SECRET]}&v=20150223&ll&ll=#{lat},#{lng}&query=restaurants')
		end
end

def four_squared(lat,lng)

end


