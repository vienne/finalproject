class ChangeColumnsInVenues < ActiveRecord::Migration
  
   def self.up
    change_column :venues, :longitude, :float
    change_column :venues, :latitude, :float
  end
 
  def self.down
    change_column :venues, :longitude, :decimal
    change_column :venues, :latitude, :decimal
  end
end
