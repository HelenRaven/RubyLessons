require_relative 'train'

class CargoTrain < Train

  attr_reader :type

  def initialize(number)
    @type = :cargo
    super
  end

  def attach_wagon(wagon)
    if wagon.type == self.type
    super
    end
  end

  def info
    print "Грузовой "
    super
  end

end
