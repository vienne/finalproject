class AddGradeToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :grade, :string, length: 1
  end
end
