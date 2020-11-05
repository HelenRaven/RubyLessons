require_relative 'instance_counter'

class Station

  include InstanceCounter

  attr_reader :trains, :name

  @@stations = {}

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@stations[name] = self
    register_instance
  end

  def arrive_train(train)
      @trains << train
  end

  def departure_train(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.select{|train| train.type == type}
  end

  def print_trains
    puts "На станции '#{self.name}' находятся поезда:"
    @trains.each {|train| train.info_full}
  end

  private

  def validate!
    raise "Station's name should be String - type!" if name.class != String
    raise "Station's name can't be empty!" if name.empty?
    raise "Station with name '#{name}' already exists!" unless @@stations[name].nil?
  end

end
