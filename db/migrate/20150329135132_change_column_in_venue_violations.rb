class ChangeColumnInVenueViolations < ActiveRecord::Migration
  def change
  	change_column :venue_violations, :violation_date, :string
  end
end
