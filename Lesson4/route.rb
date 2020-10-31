# ROUT -------------------------------------------------------------------------

class Route

  attr_reader :stations, :is_ring

  def initialize(start, finish)
    @is_ring = start == finish
    @stations = [start]
    @stations << finish unless @is_ring
  end

  def print_full
    puts "Начало маршрута: Станция '#{@stations[0].name}'"
    i = @is_ring ? 1 : 2
    if @stations.size > i
      interm_route = @stations.slice(1, @stations.size - i)
      interm_route.each.with_index(1) {|station, index| puts "Станция № #{index} - '#{station.name}'."}
    end
    i =  1 - i
    puts "Конец маршрута: Станция '#{@stations[i].name}'"
  end

  def print_short
   puts "Начало маршрута: Станция '#{@stations[0].name}'"
   if @is_ring
      puts "Маршрут кольцевой"
    else
     puts "Конец маршрута: Станция '#{@stations.last.name}'"
   end
  end

  def print_in_line
    @stations.each {|station| print " - '#{station.name}'"}
    print " - '#{@stations[0].name}'" if @is_ring
    puts""
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

  def not_empty_ring?
    @stations.size > 1 && @is_ring
  end

  def have_stations_to_delete?
    self.not_empty_ring? || !@is_ring && @stations.size > 2
  end
end
