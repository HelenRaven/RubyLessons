require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :trains, :name

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    register_instance
  end

  def arrive_train(train)
    @trains << train
    puts "На станцию #{@name} прибыл поезд #{train.number}"
  end

  def departure_train(train)
      puts "Со станции #{@name} отправился поезд #{train.number}" if @trains.delete(train)
  end

  def trains_by_type(type)
    specific_trains = @trains.select{|train| train.type == type}
    puts "На станции #{@name} нет поездов типа #{type}" if specific_trains.length == 0
    specific_trains
  end

  def print_trains
    puts "На станции '#{self.name}' находятся поезда:"
    @trains.each {|train| train.info_full}
  end
end
