class ArDecrementProduct < ActiveRecord::Base
  validates :available, numericality: {greater_than_or_equal_to: 0}
  def take!
    decrement!(:available, 1)
    self
  end
end
