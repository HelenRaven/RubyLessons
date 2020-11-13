# frozen_string_literal: true

require_relative 'manufacturer_name'
require_relative 'accessors'
require_relative 'validation'

class Wagon
  include ManufacturerName
  include Validation
  extend Accessors

  attr_accessor :capacity, :occuped

  attr_accessor_with_history :train_number

  validate :capacity, :positive

  def initialize(capacity)
    @capacity = capacity
    validate!
    @occuped = 0
    self.train_number = nil
  end

  def attached?
    train_number != nil
  end

  def available
    @capacity - @occuped
  end
end
