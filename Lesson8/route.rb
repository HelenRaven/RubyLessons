# frozen_string_literal: true

require_relative 'instance_counter'

class Route
  include InstanceCounter
  include Validation

  attr_reader :stations

  def initialize(start, finish)
    @ring = start == finish
    @stations = [start]
    @stations << finish unless @ring
    register_instance
  end

  def add_station(station, number)
    raise 'Station is already on the Route!' if @stations.include?(station)

    i = @ring ? 0 : 1
    raise 'Incorrect position number for inserting station!' if number <= 0 || number > @stations.size - i

    @stations.insert(number, station)
  end

  def delete_station(station)
    if ([@stations.first, @stations.last].include?(station) && !@ring) || (@stations.first == station && @ring)
      raise "Can't delete start/finish station!"
    end

    @stations.delete(station)
  end

  def ring?
    @ring
  end

  def empty_ring?
    @stations.size == 1 && @ring
  end

  def stations_to_delete?
    !empty_ring? || (!@ring && @stations.size > 2)
  end
end
