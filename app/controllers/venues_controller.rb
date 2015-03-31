class VenuesController < ApplicationController

	def index
		origin_address = Geokit::Geocoders::MultiGeocoder.geocode(params[:origin])
		origin_lng = origin_address.lng || -73.9894290
		origin_lat = origin_address.lat || 40.7393080

		@venues = Venue.where(latitude: (origin_lat - (1/345.00)..origin_lat + (1/345.00)), longitude: (origin_lng - (1/345.00)..origin_lng + (1/345.00)))

		respond_to do |format|
      format.html { render :index }
      format.json { render json: @venues }
    end
	end

	def near
		# lat, lng = 40.7393080, -73.9894290
		# lat, lng = near_params.lat, near_params.lng
	
		origin_address = Geokit::Geocoders::MultiGeocoder.geocode(params[:location][:address])
		@origin= {lat: origin_address.lat, lng: origin_address.lng}

		@nearby = Venue.includes(venue_violations: :violation).where(
			latitude: (lat-(1/345.00)..lat+(1/345.00)), 
			longitude: (lng-(1/345.00)..lng+(1/345.00))
		)

		@venues = @nearby.map do |venue|
			{
				name: venue.name,
				violations: venue.venue_violations.map do |vv|
					{
						date: vv.violation_date,
						description: vv.violation.violation_description
					}
				end
			}
		end
		
		respond_to do |format|
      format.html { render :index }
      format.json { render json: @origin }
    end
		# render json: @venues
	end

	private

	def near_params
		@near_params ||= params.require(:location).permit(:address)
	end

end