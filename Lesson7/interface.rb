require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

class Interface

  attr_reader :stations, :trains, :routs, :wagons

  def initialize
    @stations = []
    @trains = []
    @routs = []
    @wagons = []
  end

# Создание объектов и внесение их в массивы объектов -------------------------------------------

  def make_station
    print"Введите название станции:"
    name = gets.chomp
    @stations << Station.new(name)
    rescue RuntimeError => e
      puts e.message
    retry
  end

  def make_wagon
    print"Введите тип вагона (cargo/passenger):"
    type = gets.chomp.to_sym
    print "Введите вместимость вагона:"
    capacity = gets.to_i

    case type
      when :cargo
        @wagons << CargoWagon.new(capacity)
      when :passenger
        @wagons << PassengerWagon.new(capacity)
      else
        raise "Undefined wagon type!"
    end

    rescue RuntimeError => e
      puts e.message
    retry
  end

  def make_train
    print"Введите номер поезда: "
    number = gets.chomp
    print"Введите тип поезда (cargo/passenger): "
    type = gets.chomp.to_sym

    case type
      when :cargo
        @trains << CargoTrain.new(number)
      when :passenger
        @trains << PassengerTrain.new(number)
      else
        raise "Undefined train type!"
    end

    rescue RuntimeError => e
      puts e.message
    retry
  end

  def make_route
    if @stations.size != 0
      puts "Start station:"
      start = choose_station

      puts "End station:"
      finish = choose_station

      @routs << Route.new(start,finish)
    else
      puts "Сначала создайте станции!"
    end

    rescue RuntimeError => e
      puts e.message
  end

# Печать информации ------------------------------------------------------------------------

  def routs_list
    @routs.each.with_index(1) do |route, index|
      print "Route №#{index}: "
      route.stations.each {|station| print "- '#{station.name}' "}
      if route.is_ring
        puts "- #{route.stations.first.name}"
      else
        puts ""
      end
    end
  end

  def route_info(route)
    puts "Начало маршрута: Станция '#{route.stations[0].name}'"
    i = route.is_ring ? 1 : 2
    if route.stations.size > i
      interm_route = route.stations.slice(1, route.stations.size - i)
      interm_route.each.with_index(1) {|station, index| puts "Станция № #{index} - '#{station.name}'."}
    end
    i =  1 - i
    puts "Конец маршрута: Станция '#{route.stations[i].name}'"
  end


  def wagons_list
    @wagons.each.with_index(1) {|wagon, index| puts "Wagon №#{index}: type = #{wagon.type}, capacity = #{wagon.capacity}, available = #{wagon.available}, attached to train: #{wagon.train_number}"}
  end

  def wagons_in_train(train)
    train.each_wagon {|wagon, index| puts "Wagon №#{index}: type = #{wagon.type}, capacity = #{wagon.capacity}, available = #{wagon.available}, attached to train: #{wagon.train_number}"}
  end

  def trains_list(full = false)
    @trains.each.with_index(1) do |train, index|
      puts "Train №#{index}: type = #{train.type}, number = #{train.number}, wagons attached = #{train.wagons.size}"
      wagons_in_train(train) if full
    end
  end

  def trains_in_station(station)
    station.each_train {|train, index| puts "Train №#{index}: type = #{train.type}, number = #{train.number}, wagons attached = #{train.wagons.size}"}
  end

  def stations_list(full = false)
    @stations.each.with_index(1) do |station, index|
      puts "Station №#{index} - '#{station.name}'"
      trains_in_station(station) if full
    end
  end

# Печать менюшек ------------------------------------------------------------------------------------

  def print_menu
    puts"Введите команду: "
    puts" 1 - создать объект (станция, маршрут, поезд, вагон)."
    puts" 2 - операции с объектами."
    puts" 3 - вывести данные об объектах."
    puts" 4 - вывести меню."
    puts" 0 - закончить программу."
  end

  def print_menu_create
    puts"Введите команду: "
    puts" 1 - создать станцию."
    puts" 2 - создать маршрут."
    puts" 3 - создать поезд."
    puts" 4 - создать вагон"
    puts" 5 - вывести меню."
    puts" 0 - вернуться в предыдущее меню."
  end

  def print_menu_operations
    puts"Введите команду: "
    puts" 1 - добавить/удалить станции в маршрут."
    puts" 2 - добавить/отцепить вагоны к поезду."
    puts" 3 - установить маршрут поезда."
    puts" 4 - переместить поезд вперед/назад по маршруту."
    puts" 5 - добавить/убрать из вагона."
    puts" 6 - вывести меню."
    puts" 0 - вернуться в предыдущее меню."
  end

  def print_menu_info
    puts"Введите команду : "
    puts" 1 - напечатать список станций / список поездов на станции."
    puts" 2 - напечатать список маршрутов / распечатать маршрут."
    puts" 3 - напечатать список поездов / информацию о поезде / маршрут поезда. "
    puts" 4 - напечатать список вагонов."
    puts" 5 - вывести меню."
    puts" 0 - вернуться в предыдущее меню."
  end

# Функции для выбора объекта из списка -------------------------------------------------------------------

  def user_answer_to_i
    gets.to_i - 1
  end

  def validate_number(number,ary)
    raise "Wrong number!" if number >= ary.size || number < 0
  end

  def choose_train
    trains_list(false)
    print "Выберите порядковый номер поезда:"
    i = user_answer_to_i
    validate_number(i, trains)
    trains[i]
  end

  def choose_route
    routs_list
    print "Выберите номер маршрута:"
    i = user_answer_to_i
    validate_number(i, routs)
    routs[i]
  end

  def choose_station
    stations_list(false)
    print "Выберите порядковый номер станции:"
    i = user_answer_to_i
    validate_number(i, stations)
    stations[i]
  end

  def choose_wagon
    wagons_list
    print "Введите номер вагона"
    i = user_answer_to_i
    validate_number(i, wagons)
    wagons[i]
  end

# Функции - действия с объектами -------------------------------------------------------------------------

  def station_to_route
    route = choose_route

    print "Что будем делать: добавлять (1) или удалять (0) станции из маршрута?:"
    operation = gets.to_i

    case operation
      when 0
        if route.have_stations_to_delete?
          route_info(route)
          print "Выберите номер станции, которую нужно удалить:"
          j = gets.to_i

          route.delete_station(route.stations[j])
        else
          print "Из маршрута нельзя удалять станции"
        end
      when 1
        station = choose_station
        k = route.is_ring ? route.stations.size : route.stations.size - 1

        route.add_station(station, k)
    end

    rescue RuntimeError => e
      puts e.message
  end

  def wagon_to_train
    train = choose_train

    print "Что будем делать: прицеплять (1) или отцеплять (0) вагон от поезда?:"
    operation = gets.to_i

    case operation
      when 0
        if train.wagons.size != 0
          train.detach_wagon(train.wagons.last)
        else
          print "К этому поезду не прицеплено ни одного вагона!"
        end
      when 1
        wagon = choose_wagon
        train.attach_wagon(wagon)
      end

    rescue RuntimeError => e
      puts e.message
  end

  def route_to_train
    train = choose_train
    route = choose_route
    train.get_route(route)

    rescue RuntimeError => e
      puts e.message
  end

  def move_train
    train = choose_train
    loop do
      print "Ехать вперед (1), ехать назад (-1), выйти в меню (0):"
      answer = gets.to_i

      case answer
      when 1
        puts "Train #{train.number} departure at '#{train.station.name}' station."
        train.go_forward
        puts "Train #{train.number} arrive at '#{train.station.name}' station."
      when -1
        puts "Train #{train.number} departure at '#{train.station.name}' station."
        train.go_back
        puts "Train #{train.number} arrive at '#{train.station.name}' station."
      when 0
        break
      end

      rescue RuntimeError => e
        puts e.message
      retry
    end
  end

  def volume_to_wagon
    wagon = choose_wagon

    print "Бдем добавлять(1) или убирать (0) из вагона?"
    answer = gets.to_i

    case answer
      when 0
        case wagon.type
        when :passenger
          wagon.free_place
        when :cargo
          print "Введите объем, которы убираем:"
          vol = gets.to_i
          wagon.unload(vol)
        end
      when 1
        case wagon.type
        when :passenger
          wagon.take_place
        when :cargo
          print "Введите объем, которые загружаем:"
          vol = gets.to_i
          wagon.upload(vol)
        end
    end

    rescue RuntimeError => e
        puts e.message
    retry
  end
# Обработки меню ----------------------------------------------------------------------------------------

  def create_menu
    loop do
      answer = gets.to_i
      case answer
        when 1
          make_station
        when 2
          make_route
        when 3
          make_train
        when 4
          make_wagon
        when 5
          print_menu_create
        when 0
          break
      end
      print "Введите следующую команду (5 - текущее меню, 0 - основное меню):"
    end
  end

  def operations_menu
    loop do
      answer = gets.to_i
      case answer
        when 1
          station_to_route
        when 2
          wagon_to_train
        when 3
          route_to_train
        when 4
          move_train
        when 5
          volume_to_wagon
        when 6
          print_menu_operations
        when 0
          break
      end
      print"Введите следующую команду (6 - текущее меню, 0 - основное меню):"
    end
  end

  def info_menu
    loop do
      answer = gets.to_i
      case answer
        when 1
          stations_list(true)
        when 2
          routs_list
        when 3
          trains_list(true)
        when 4
          wagons_list
        when 5
          print_menu_info
        when 0
          break
      end
      print"Введите следующую команду (5 - текущее меню, 0 - основное меню):"
    end
  end

  def run
    loop do
      print_menu
      answer = gets.to_i

      case answer
        when 1
          print_menu_create
          create_menu

        when 2
          print_menu_operations
          operations_menu

        when 3
          print_menu_info
          info_menu

        when 4
          print_menu

        when 0
          break
      end
      print"Введите следующую команду (4 - вывести меню снова):"
    end
  end

end
