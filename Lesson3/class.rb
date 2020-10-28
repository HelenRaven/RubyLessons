# STATION ------------------------------------------------------------------

class Station

  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def arrive_train(train)
    @trains << train
    puts "На станцию #{@name} прибыл поезд #{train.number}"
  end

  def departure_train(train)
      puts "Со станции #{@name} отправился поезд #{train.number}" if @trains.reject!{|obj| obj == train} != nil
  end

  def trains_by_type(type)
    specific_trains = []
    @trains.each {|train| specific_trains << train if train.type == type}
    puts "На станции #{@name} нет поездов типа #{type}" if specific_trains.length == 0
    return specific_trains
  end

  def print_trains
    @trains.each {|train| puts train.number}
  end

end

# ROUT -------------------------------------------------------------------------

class Route
  attr_reader :stations, :is_ring

  def initialize(start, finish)
    @stations = []
    @is_ring = false
    @is_ring = true if start == finish
    @stations << start
    @stations << finish
  end

  def print
    puts "Начало маршрута: Станция '#{@stations[0].name}'"
    if @stations.size > 2
      interm_route = @stations.slice(1, @stations.size - 2)
      interm_route.each.with_index(1) {|station, index| puts "Станция № #{index} - '#{station.name}'."}
    end
    puts "Конец маршрута: Станция '#{@stations[-1].name}'"
  end

  def add_station(station, number)
    if @stations.include?(station)
      puts "Станция '#{station.name}' уже есть на маршруте."
    else
      if number == 0
        self.print
        puts "Введите номер, куда будет помещена станция на маршруте:"
        number = gets.to_i
      end
      @stations.insert(number, station) if number <= @stations.size - 1 && number > 0
    end
  end

  def delete_station (station)
    @stations.reject!{|obj| obj == station} if @stations[0] != station && @stations[-1] != station
  end
end

#TRAIN ------------------------------------------------------------

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
    @route = route
    @station = route.stations[0]
    @station.arrive_train(self)
    @next_station = route.station s[1]
    @station_i = 0
    @prev_station = route.stations[-2] if @route.is_ring
  end

  def go_forward
    if @station_i < @route.stations.size - 1 && !(@route.stations.size == 2 && @route.is_ring)
      @station_i += 1
      @station.departure_train(self)
      if @station_i == @route.stations.size - 1 && @route.is_ring
        @station = @route.stations[0]
        @next_station = @route.stations[1]
        @prev_station = @route.stations[-2]
        @station_i = 0
      else
        @prev_station = @station
        @station = @route.stations[@station_i]
        @next_station = @route.stations[@station_i + 1]
      end
      @station.arrive_train(self)
    end
  end

  def go_back
    if ((@station_i > 0 && !@route.is_ring) || @route.is_ring) && !(@route.stations.size == 2 && @route.is_ring)
      @station_i -= 1
      @station.departure_train(self)
      if @station_i == -1
        @station = @route.stations[-2]
        @next_station = @route.stations[0]
        @prev_station = @route.stations[-3]
        @station_i = @route.stations.size - 2
      else
        @next_station = @station
        @station = @route.stations[@station_i]
        @prev_station = @route.stations[@station_i - 1]
      end
      @station.arrive_train(self)
   end
  end

end


s1 = Station.new("s1")
s2 = Station.new("s2")
s3 = Station.new("s3")
s4 = Station.new("s4")
s5 = Station.new("s5")
s6 = Station.new("s6")

r1 = Route.new(s1,s6)
r2 = Route.new(s5,s5)

t1 = Train.new(1,"g",5)
t2 = Train.new(2,"t",5)
t3 = Train.new(3,"g",5)
