class DbCheckProduct < ActiveRecord::Base

  def take!
    sql = "UPDATE #{self.class.table_name} SET available = available - 1 WHERE id = #{self.id} AND available IS NOT NULL RETURNING available;"
    result_set = self.class.connection.execute(sql)
    if result_set.ntuples == 1
      self.available = result_set.getvalue(0, 0).to_i
    end
    self
  end

end
