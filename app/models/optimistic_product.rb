class OptimisticProduct < ActiveRecord::Base
  validates :available, numericality: {greater_than_or_equal_to: 0}
  def take!
    self.available -= 1
    save!
    self
  end
end
