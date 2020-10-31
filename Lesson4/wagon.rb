class Wagon

  attr_accessor :train_number, :is_attached

  def initialize
    @is_attached = false
    @train_number = nil
  end

  def info
    if self.is_attached
      print "вагон, прицеплен к поезду №#{self.train_number}.\n"
    else
      print "вагон, не прицеплен.\n"
    end
  end

end

class CargoWagon < Wagon

attr_reader :type

  def initialize
    @type = :cargo
    super
  end

  def info
    print "Грузовой "
    super
  end

end

class PassengerWagon < Wagon

  attr_reader :type
  def initialize
    @type = :passenger
    super
  end

  def info
    print "Пассажирский "
    super
  end
end
