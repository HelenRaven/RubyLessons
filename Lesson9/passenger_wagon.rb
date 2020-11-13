# frozen_string_literal: true

require_relative 'wagon'

class PassengerWagon < Wagon
  attr_reader :type

  def initialize(number_of_places = 54)
    @type = :passenger
    super
  end

  def take_place
    raise 'No free places!' if @occuped == @capacity

    @occuped += 1
  end

  def free_place
    raise 'All places are free!' if @occuped.zero?

    @occuped -= 1
  end
end
