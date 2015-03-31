class Violation < ActiveRecord::Base
	has_many :venue_violations
	has_many :venues, through: :venue_violations
end