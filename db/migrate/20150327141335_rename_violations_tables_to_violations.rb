class RenameViolationsTablesToViolations < ActiveRecord::Migration
  def change
  	rename_table :violations, :violations_tables
  end
end
