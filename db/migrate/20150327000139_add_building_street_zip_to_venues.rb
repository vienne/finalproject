class AddBuildingStreetZipToVenues < ActiveRecord::Migration
  def change
  	add_column :venues, :building, :string
  	add_column :venues, :street, :string
  	add_column :venues, :zip, :string
  end
end
