class CreateTestTable < ActiveRecord::Migration
  def change
    create_table :test_tables do |t|
      t.string :name
    end
  end
end
