class VenueViolation < ActiveRecord::Base
	belongs_to :venue
	belongs_to :violation
end
