class PessimisticProduct < ActiveRecord::Base
  validates :available, numericality: {greater_than_or_equal_to: 0}
  def take!
    with_lock do
      self.available -= 1
      save!
    end
    self
  end
end
