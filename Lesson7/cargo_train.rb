require_relative 'train'

class CargoTrain < Train

  MAX_SPEED = 100

  attr_reader :type

  def initialize(number)
    @type = :cargo
    super
  end

  def attach_wagon(wagon)
    raise "Wagon type and Train type do not match!" if @type != wagon.type
    super
  end

end
