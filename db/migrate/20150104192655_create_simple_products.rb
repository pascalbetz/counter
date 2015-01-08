class CreateSimpleProducts < ActiveRecord::Migration
  def change
    create_table :simple_products do |t|
      t.integer :available

      t.timestamps null: false
    end
  end
end
