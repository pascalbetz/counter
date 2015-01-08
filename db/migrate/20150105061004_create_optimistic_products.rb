class CreateOptimisticProducts < ActiveRecord::Migration
  def change
    create_table :optimistic_products do |t|
      t.integer :available
      t.integer :lock_version, default: 0

      t.timestamps null: false
    end
  end
end
