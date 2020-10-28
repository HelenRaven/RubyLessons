# ROUT -------------------------------------------------------------------------

class Route
  attr_reader :stations, :is_ring

  def initialize(start, finish)
    @is_ring = start == finish
    @stations = [start]
    @stations << finish unless @is_ring
  end

  def print
    puts "Начало маршрута: Станция '#{@stations[0].name}'"
    i = @is_ring ? 1 : 2
    if @stations.size > i
      interm_route = @stations.slice(1, @stations.size - i)
      interm_route.each.with_index(1) {|station, index| puts "Станция № #{index} - '#{station.name}'."}
    end
    i =  1 - i
    puts "Конец маршрута: Станция '#{@stations[i].name}'"
  end

  def add_station(station, number)
    if @stations.include?(station)
      puts "Станция '#{station.name}' уже есть на маршруте."
    else
      i = @is_ring ? 0 : -1
      @stations.insert(number, station) if number > 0 && number <= @stations.size - i
    end
  end

  def delete_station (station)
    @stations.delete(station) unless ([@stations.first,@stations.last].include?(station) && !@is_ring) || (@stations.first == station && @is_ring)
  end
end
