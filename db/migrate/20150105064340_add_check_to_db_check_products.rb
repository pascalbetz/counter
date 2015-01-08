class AddCheckToDbCheckProducts < ActiveRecord::Migration
  def up
    execute "alter table db_check_products add constraint check_available \
      check (available IS NULL OR available >= 0)"
  end

  def down
    execute 'alter table db_check_products drop constraint check_available'
  end
end
