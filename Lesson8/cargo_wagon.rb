# frozen_string_literal: true

require_relative 'wagon'

class CargoWagon < Wagon
  attr_reader :type

  def initialize(volume)
    @type = :cargo
    super
    validate!
  end

  def upload(vol)
    raise 'Not enouth volume for loading!' if (@occuped + vol) > @capacity

    @occuped += vol
  end

  def unload(vol)
    raise 'There is not so much volume to unload!' if (@occuped - vol).negative?

    @occuped -= vol
  end

  private

  def validate!
    raise 'Wagon volume must be greater than 0!' if capacity <= 0
  end
end
