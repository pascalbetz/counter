class CreateArDecrementProducts < ActiveRecord::Migration
  def change
    create_table :ar_decrement_products do |t|
      t.integer :available

      t.timestamps null: false
    end
  end
end
