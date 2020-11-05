require_relative 'manufacturer_name'
require_relative 'instance_counter'
require_relative 'validation'

class Train

  include ManufacturerName
  include InstanceCounter
  include Validation

  NUMBER_FORMAT = /^([a-zа-я]|\d){3}-?([a-zа-я]|\d){2}$/i

  @@trains = {}


  def self.find(number)
    @@trains[number]
  end

  attr_reader :speed, :station, :number, :wagons

  def initialize(number)
    @number = number
    raise "Train with number #{number} already exists!" if @@trains[number] != nil
    validate!
    @speed = 0
    @wagons = []
    @@trains[number] = self
    register_instance
   end

  def pick_up_speed(volume)
    @speed += volume
  end

  def slow_down(volume)
    @speed -= volume
    self.stop if self.stopped?
  end

  def stopped?
    self.speed <= 0
  end

  def stop
    @speed = 0
  end

  def attach_wagon(wagon)
    if self.stopped? && !wagon.is_attached
      @wagons << wagon
      wagon.is_attached = true
      wagon.train_number = self.number
    else
      puts "Вагон не был прицеплен"
    end
  end

  def detach_wagon(wagon)
    if self.stopped?
      if @wagons.delete(wagon)
        wagon.is_attached = false
        wagon.train_number = nil
      end
    end
  end

  def info
    print "Поезд №#{self.number},количество вагонов: #{@wagons.size}\n"
    puts "На станции #{@station.name} " if @route != nil
  end

  def info_full
    self.info
    if @route != nil
      print "Mаршрут: "
      @route.print_in_line
    end
  end

  def number_of_wagons
    @wagons.size
  end

  def get_route(route)
    if self.stopped?
      @station.departure_train(self) if @station != nil
      @route = route
      @station = route.stations[0]
      @station.arrive_train(self)
    end
  end

  def next_station
    i = self.current_station_index
    (@route.is_ring && self.at_finish?) ? @route.stations[0] : @route.stations[i + 1]
  end

  def prev_station
    i = self.current_station_index
    (!@route.is_ring && self.at_start?) ? nil : @route.stations[i - 1]
  end

  def go_forward
    if !self.at_finish? || @route.not_empty_ring?
      @station.departure_train(self)
      @station = self.next_station
      @station.arrive_train(self)
    end
  end

  def go_back
    if !self.at_start? || @route.not_empty_ring?
      @station.departure_train(self)
      @station = self.prev_station
      @station.arrive_train(self)
   end
  end

  def at_finish?
    self.current_station_index == self.last_station_index
  end

  def at_start?
    self.current_station_index == 0
  end

  private

  def validate!
    raise "Wrong number format!" if number !~ NUMBER_FORMAT
  end

  def current_station_index
    @route.stations.index(@station)
  end

  def last_station_index
    @route.stations.size - 1
  end

end

