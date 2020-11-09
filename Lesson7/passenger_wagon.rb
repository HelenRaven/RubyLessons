require_relative 'wagon'

class PassengerWagon < Wagon

  attr_reader :type

  def initialize(number_of_places = 54)
    @type = :passenger
    super
    validate!
  end

  def take_place
    raise "No free places!" if @occuped == @capacity
    @occuped += 1
  end

  def free_place
    raise "All places are free!" if @occuped == 0
    @occuped -= 1
  end

  def available
    @capacity - @occuped
  end

  private

  def validate!
    raise "Number of places must be greater than 0!" if capacity < 1
  end

end