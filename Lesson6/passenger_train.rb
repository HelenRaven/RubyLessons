require_relative 'train'

class PassengerTrain < Train

  attr_reader :type

  def initialize(number)
    @type = :passenger
    super
  end

  def attach_wagon(wagon)
    if wagon.type == self.type
    super
    end
  end

  def info
    print "Пассажирский "
    super
  end

end
