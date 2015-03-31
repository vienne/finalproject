class ChangeDateToStringInAllData < ActiveRecord::Migration
  def change
  	change_column :all_data, :inspection_date, :string
  	change_column :all_data, :grade_date, :string
  	change_column :all_data, :record_date, :string
  end
end
