# frozen_string_literal: true

require_relative 'manufacturer_name'
require_relative 'instance_counter'
require_relative 'validation'

class Train
  include ManufacturerName
  include InstanceCounter
  include Validation

  NUMBER_FORMAT = /^([a-zа-я]|\d){3}-?([a-zа-я]|\d){2}$/i.freeze
  MAX_SPEED = 250

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  attr_reader :speed, :station, :number, :wagons

  def initialize(number)
    @number = number.to_s
    raise "Train with number #{number} already exists!" unless @@trains[number].nil?

    validate!
    @speed = 0
    @wagons = []
    @@trains[number] = self
    register_instance
  end

  def pick_up_speed(volume)
    @speed += volume
    @speed = MAX_SPEED if @speed > MAX_SPEED
  end

  def slow_down(volume)
    @speed -= volume
    stop if stopped?
  end

  def stopped?
    @speed <= 0
  end

  def stop
    @speed = 0
  end

  def attach_wagon(wagon)
    validate_stop!
    raise 'This Wagon already attached!' if wagon.attached?

    @wagons << wagon
    wagon.train_number = @number
  end

  def detach_wagon(wagon)
    validate_stop!
    wagon.train_number = nil if @wagons.delete(wagon)
  end

  def number_of_wagons
    @wagons.size
  end

  def get_route(route)
    validate_stop!
    @station&.departure_train(self)
    @route = route
    @station = route.stations[0]
    @station.arrive_train(self)
  end

  def next_station
    i = current_station_index
    @route.ring? && at_finish? ? @route.stations[0] : @route.stations[i + 1]
  end

  def prev_station
    i = current_station_index
    !@route.ring? && at_start? ? nil : @route.stations[i - 1]
  end

  def go_forward
    raise "Can't go forward!" unless road_ahead?

    @station.departure_train(self)
    @station = next_station
    @station.arrive_train(self)
  end

  def go_back
    raise "Can't go back!" unless road_behind?

    @station.departure_train(self)
    @station = prev_station
    @station.arrive_train(self)
  end

  def at_finish?
    current_station_index == last_station_index
  end

  def at_start?
    current_station_index.zero?
  end

  def road_ahead?
    @route.ring? ? !@route.empty_ring? : !at_finish?
  end

  def road_behind?
    @route.ring? ? !@route.empty_ring? : !at_start?
  end

  def each_wagon(&block)
    @wagons.each.with_index(1, &block)
  end

  private

  def validate_stop!
    raise 'Train is moving!' unless stopped?
  end

  def validate!
    raise 'Wrong number format!' if number !~ NUMBER_FORMAT
  end

  def current_station_index
    @route.stations.index(@station)
  end

  def last_station_index
    @route.stations.size - 1
  end
end
