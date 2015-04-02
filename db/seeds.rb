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
INSERT INTO venue_violations (venue_id, violation_id, violation_date, created_at, updated_at)
SELECT venues.id AS venue_id, violations.id AS violation_id, all_data.inspection_date AS violation_date, NOW(), NOW()
FROM all_data
LEFT JOIN venues ON venues.camis = all_data.camis
LEFT JOIN violations ON violations.violation_code = all_data.violation_code
WHERE all_data.inspection_date > '2013-12-31'
SQL

sql.execute <<-SQL
WITH cuisines AS 
	(
	SELECT camis AS cam, cuisine AS cui 
	FROM all_data
	GROUP BY camis, cuisine
	)
UPDATE venues
SET cuisine = cui
FROM cuisines
WHERE venues.camis = cam
SQL


sql.execute <<-SQL
UPDATE venues SET grade = c.grade
FROM
(SELECT b.camis, b.grade, b.grade_date FROM (
  SELECT camis, MAX(grade_date) max_grade_date
  FROM all_data
  WHERE grade_date > '2013-12-31'::date
  GROUP BY camis
) a LEFT JOIN all_data b ON a.camis = b.camis AND a.max_grade_date = b.grade_date
GROUP BY b.camis, b.grade, b.grade_date) c
WHERE venues.camis = c.camis
SQL

__END__

