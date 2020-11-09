require_relative 'instance_counter'
require_relative 'each'

class Station

  include InstanceCounter
  include Validation
  include Each

  attr_reader :trains, :name

  @@stations = {}

  def self.all
    @@stations
  end

  def initialize(name)
    raise "Station with name '#{name}' already exists!" unless @@stations[name].nil?
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

  #def each_inside(&block)
  #  @trains.each.with_index(1) {|train, index| block.call(train, index)}
  #end

  private

  def validate!
    raise "Station's name should be String - type!" if name.class != String
    raise "Station's name can't be empty!" if name.empty?
  end

end
