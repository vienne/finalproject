class CreateVenueViolations < ActiveRecord::Migration
  def change
    create_table :venue_violations do |t|
    	t.integer :venue_id
    	t.integer :violation_id
    	t.date	:violation_date

    	t.timestamps null: false
    end
  end
end
