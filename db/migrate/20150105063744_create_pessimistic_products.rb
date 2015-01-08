class CreatePessimisticProducts < ActiveRecord::Migration
  def change
    create_table :pessimistic_products do |t|
      t.integer :available

      t.timestamps null: false
    end
  end
end
