class ChangeColumnInAllData < ActiveRecord::Migration
  def change
  	change_column :all_data, :inspection_date, 'date USING CAST(inspection_date AS date)'
  	change_column :all_data, :record_date, 'date USING CAST(record_date AS date)'
  	change_column :all_data, :record_date, 'date USING CAST(record_date AS date)'
  end
end
