# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



def sql
	ActiveRecord::Base.connection
end

#creating all_data table
sql.execute <<-SQL
COPY all_data (camis,dba,boro,building,street,zip,phone,cuisine,inspection_date,action,violation_code,violation_description,critical_flag,score,grade,grade_date,record_date,inspection_type)
FROM '/Users/Vienne/src/projects/venue_data.csv'
CSV HEADER DELIMITER AS ','
SQL

#creating the venues table
sql.execute <<-SQL
INSERT INTO venues (camis, name, boro, building, street, zip, phone, created_at,updated_at )
SELECT camis, dba, boro, building, street, zip, phone, NOW(), NOW()
FROM all_data
WHERE inspection_date > '2013-12-31'
GROUP BY camis, dba, boro, building, street, zip, phone
SQL
#concacting three column  into one address column
sql.execute <<-SQL
update venues set address = building || ' ' || street || ' ' || zip
SQL

#taking out the weird spaces in address, run this a few times
sql.execute <<-SQL
UPDATE venues SET address =  REPLACE(address, '  ', ' ') 
SQL

#creating a table of each violation
sql.execute <<-SQL
INSERT INTO violations_tables (violation_code, violation_description, created_at, updated_at)
SELECT distinct violation_code, violation_description, NOW(), NOW()
FROM all_data
SQL

sql.execute <<-SQL
INSERT INTO venue_violations
SELECT venues.id, violations.id, all_data.inspection_date
FROM all_data
LEFT JOIN venues ON venues.camis = all_data.camis
LEFT JOIN violations ON violations.violation_code = all_data.violation_code
SQL

__END__


# require 'date'

# Venue.delete_all

# json_venues = File.read('db/venues.json')

# parsed_venues = JSON.parse(json_venues)

# venue_data = parsed_venues['data']

# ### CREATE THE VENUES ###


# venues = venue_data.map do |violation|
# 	# you want to return just the data about the venue
# 	# no data aboutviolations
# end

# # grab unique venues
# venues.uniq!

# venues.each do |venue|
# 	Venue.create
# end



# ### CREATE THE VIOLATIONS ###

# current_violations = venue_data.select do |violation|
# 	# only select the violations after 
# 	# the right date
# end

# Venue.all.each do |venue|
# 	venue_violations = current_violations.select do |violation|
# 		# select all the violations whos name
# 		# matches the venue name
# 	end

# 	venue_violations.each do |violation|
# 		Violation.create
# 	end
# end


# violations.each do |venue|
#   address_hash = JSON.parse(venue[7])
#   address = violations[12] + " " + violations[13]

#   # GEOCODE IN HERE? 

#   if Date.parse(venue[]) > Date.parse('2013-12-31')

#   	date = Date.parse(venue[])

#   	Venue.create({
# 		  name: venue[10],
# 		  boro: venue[11],
# 		  address: address,
# 		  zip: venue[14],
# 		  cuisine: venue[16],
# 		  inspection_date: date,
# 		  phone: venue[15]
#   	})
# 	end
# end

# [[1, 2, 3,], [1, 2, 3], [1,2,3]]
