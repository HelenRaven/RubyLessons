require_relative 'instance_counter'

class Route

  include InstanceCounter
  include Validation

  attr_reader :stations, :is_ring

  def initialize(start, finish)
    @is_ring = start == finish
    @stations = [start]
    @stations << finish unless @is_ring
    validate!
    register_instance
  end

  def add_station(station, number)
    raise "Station is already on the Route!" if @stations.include?(station)
    i = @is_ring ? 0 : 1
    raise "Incorrect position number for inserting station!" if number <= 0 || number > @stations.size - i
    @stations.insert(number, station)
  end

  def delete_station (station)
    raise "Can't delete start/finish station!" if ([@stations.first,@stations.last].include?(station) && !@is_ring) || (@stations.first == station && @is_ring)
    @stations.delete(station)
  end

  def empty_ring?
    @stations.size == 1 && @is_ring
  end

  def have_stations_to_delete?
    !empty_ring? || (!@is_ring && @stations.size > 2)
  end

  private

  def validate!
    raise "Start & Finish must be Station objects!" if stations.first.class != Station || stations.last.class != Station
  end
end
