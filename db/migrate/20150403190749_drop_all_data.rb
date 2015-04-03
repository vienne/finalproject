class DropAllData < ActiveRecord::Migration
  def change
  	drop_table :all_data, force: :cascade
  end
end
