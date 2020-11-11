# frozen_string_literal: true

require_relative 'train'

class PassengerTrain < Train
  MAX_SPEED = 180

  attr_reader :type

  def initialize(number)
    @type = :passenger
    super
  end

  def attach_wagon(wagon)
    raise 'Wagon type and Train type do not match!' if @type != wagon.type

    super
  end
end
