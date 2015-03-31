class RenameViolationsTablestoViolations < ActiveRecord::Migration
  def change
  	rename_table :violations_tables, :violations
  end
end
