class CreateDbCheckProducts < ActiveRecord::Migration
  def change
    create_table :db_check_products do |t|
      t.integer :available

      t.timestamps null: false
    end
  end
end
