class CreateViolationsTable < ActiveRecord::Migration
  def change
    create_table :violations_tables do |t|
    	t.string :violation_code
    	t.string :violation_description

    	t.timestamps null: false
    end
  end
end
