
class Train

  attr_reader :number_of_wagons, :speed, :type, :station, :prev_station, :next_station, :number

  def initialize(number, type, number_of_wagons)
    @number = number
    @type = type
    @number_of_wagons = number_of_wagons
    @speed = 0
  end

  def increase_speed(increase)
    @speed += increase
  end

  def stop
    @speed = 0
  end

  def attach_wagon
    @number_of_wagons += 1 if @speed == 0
  end

  def detach_wagon
    @number_of_wagons -= 1 if @speed == 0 && @number_of_wagons > 0
  end

  def get_route(route)
    @station.departure_train(self) if @station != nil
    @route = route
    @station = route.stations[0]
    @station.arrive_train(self)
  end

  def current_station_index
    @route.stations.index(@station)
  end

  def next_station
    i = self.current_station_index
    (@route.is_ring && i == @route.stations.size - 1) ? @route.stations[0] : @route.stations[i + 1]
  end

  def prev_station
    i = self.current_station_index
    (!@route.is_ring && i == 0) ? nil : @route.stations[i - 1]
  end

  def go_forward
    i = self.current_station_index
    if i < @route.stations.size - 1 || (@route.is_ring && @route.stations.size != 1)
      @station.departure_train(self)
      @station = self.next_station
      @next_station = self.next_station
      @prev_station = self.prev_station
      @station.arrive_train(self)
    end
  end

  def go_back
    i = self.current_station_index
    if i != 0 || (@route.is_ring && @route.stations.size != 1)
      @station.departure_train(self)
      @station = self.prev_station
      @next_station = self.next_station
      @prev_station = self.prev_station
      @station.arrive_train(self)
   end
  end

end
