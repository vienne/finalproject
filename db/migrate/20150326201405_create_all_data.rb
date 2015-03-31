class CreateAllData < ActiveRecord::Migration
  def change
    create_table :all_data do |t|
    	t.string :camis
    	t.string :dba
    	t.string :boro
    	t.string :building
    	t.string :street
    	t.string :zip
    	t.string :phone
    	t.string :cuisine
    	t.string :inspection_date
    	t.string :action
    	t.string :violation_code
    	t.string :violation_description
    	t.string :critical_flag
    	t.string :score
    	t.string :grade
    	t.string :grade_date
    	t.string :record_date
    	t.string :inspection_type
    end
  end
end
