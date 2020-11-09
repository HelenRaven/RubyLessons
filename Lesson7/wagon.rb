require_relative 'manufacturer_name'

class Wagon

  include ManufacturerName

  attr_accessor :capacity, :occuped, :train_number

  def initialize(capacity)
    @capacity = capacity
    @occuped = 0
    @train_number = nil
  end

  def is_attached?
    @train_number != nil
  end

  def available
    @capacity - @occuped
  end

end

