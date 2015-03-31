class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
    	t.string :camis
    	t.string :name
    	t.string :boro
    	t.string :address
    	t.string :phone
    	t.string :cuisine
    	t.decimal :longitude
    	t.decimal :latitude

      t.timestamps null: false
    end
  end
end