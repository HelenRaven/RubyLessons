# frozen_string_literal: true

require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

class Interface
  @@create = {
    1 => :make_station,
    2 => :make_route,
    3 => :make_train,
    4 => :make_wagon,
    5 => :print_menu_create
  }
  @@operations = {
    1 => :station_to_route,
    2 => :wagon_to_train,
    3 => :route_to_train,
    4 => :move_train,
    5 => :volume_to_wagon,
    6 => :print_menu_operations
  }
  @@info = {
    1 => :stations_list,
    2 => :routs_list,
    3 => :trains_list,
    4 => :wagons_list,
    5 => :print_menu_info
  }

  attr_reader :stations, :trains, :routs, :wagons

  def initialize
    @stations = []
    @trains = []
    @routs = []
    @wagons = []
  end

  # Object creation -------------------------------------------

  def make_station
    print 'Введите название станции: '
    name = gets.chomp
    @stations << Station.new(name)
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def make_wagon
    print 'Введите тип вагона: cargo (1) / passenger (2): '
    type = gets.to_i
    print 'Введите вместимость вагона:'
    capacity = gets.to_i
    case type
    when 1
      @wagons << CargoWagon.new(capacity)
    when 2
      @wagons << PassengerWagon.new(capacity)
    else
      raise "Undefined wagon type!"
    end
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def make_train
    print 'Введите номер поезда: '
    number = gets.chomp
    print 'Введите тип поезда: cargo (1) / passenger (2): '
    type = gets.to_i
    case type
    when 1
      @trains << CargoTrain.new(number)
    when 2
      @trains << PassengerTrain.new(number)
    else
      raise "Undefined train type!"
    end
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def make_route
    if !@stations.empty?
      puts 'Start station: '
      start = choose_station
      puts 'End station: '
      finish = choose_station
      @routs << Route.new(start, finish)
    else
      puts 'Сначала создайте станции!'
    end
  rescue RuntimeError => e
    puts e.message
  end

  # Print functions ------------------------------------------------------------------------

  def routs_list
    @routs.each.with_index(1) do |route, index|
      print "Route №#{index}: "
      route.stations.each { |station| print "- '#{station.name}' " }
      if route.ring?
        puts "- #{route.stations.first.name}"
      else
        puts ''
      end
    end
  end

  def print_intermediate_stations(route)
    i = route.ring? ? 1 : 2
    k = route.stations.size - i
    # if route.stations.size > i
    route.stations[1..k].each.with_index(1) do |station, index|
      puts "Станция № #{index} - '#{station.name}'."
      #   end
    end
  end

  def route_info(route)
    puts "Начало маршрута: Станция '#{route.stations[0].name}'"
    print_intermediant_stations(route)
    i = route.ring? ? 0 : -1
    puts "Конец маршрута: Станция '#{route.stations[i].name}'"
  end

  def wagons_list
    @wagons.each.with_index(1) do |wagon, index|
      puts "Wagon №#{index}: type = #{wagon.type},"\
                          " capacity = #{wagon.capacity},"\
                          " available = #{wagon.available},"\
                          " attached to train: #{wagon.train_number}"
    end
  end

  def wagons_in_train(train)
    train.each_wagon do |wagon, index|
      puts "Wagon №#{index}: type = #{wagon.type},"\
                        " capacity = #{wagon.capacity},"\
                        " available = #{wagon.available},"\
                        " attached to train: #{wagon.train_number}"
    end
  end

  def trains_list(full: true)
    @trains.each.with_index(1) do |train, index|
      puts "Train №#{index}: type = #{train.type},"\
                          " number = #{train.number},"\
                          " wagons attached = #{train.wagons.size}"
      wagons_in_train(train) if full
    end
  end

  def trains_in_station(station)
    station.each_train do |train, index|
      puts "Train №#{index}: type = #{train.type},"\
                          " number = #{train.number},"\
                          " wagons attached = #{train.wagons.size}"
    end
  end

  def stations_list(full: true)
    @stations.each.with_index(1) do |station, index|
      puts "Station №#{index} - '#{station.name}'"
      trains_in_station(station) if full
    end
  end

  # Print menus------------------------------------------------------------------------------------

  def print_menu
    puts '-' * 40
    puts <<~PMD
      Введите команду:
      1 - создать объект (станция, маршрут, поезд, вагон).
      2 - операции с объектами.
      3 - вывести данные об объектах.
      0 - закончить программу.
    PMD
    puts '-' * 40
  end

  def print_menu_create
    puts '-' * 40
    puts <<~PMC
      Введите команду:
      1 - создать станцию.
      2 - создать маршрут.
      3 - создать поезд.
      4 - создать вагон.
      0 - вернуться в предыдущее меню.
    PMC
    puts '-' * 40
  end

  def print_menu_operations
    puts '-' * 40
    puts <<~PMO
      Введите команду:
      1 - добавить/удалить станции в маршрут.
      2 - добавить/отцепить вагоны к поезду.
      3 - установить маршрут поезда.
      4 - переместить поезд вперед/назад по маршруту.
      5 - добавить/убрать из вагона.
      0 - вернуться в предыдущее меню.
    PMO
    puts '-' * 40
  end

  def print_menu_info
    puts '-' * 40
    puts <<~PMI
      Введите команду :
      1 - напечатать список станций.
      2 - напечатать список маршрутов.
      3 - напечатать список поездов.
      4 - напечатать список вагонов.
      0 - вернуться в предыдущее меню.
    PMI
    puts '-' * 40
  end

  # Chose object from list -------------------------------------------------------------------

  def user_answer_to_i
    gets.to_i - 1
  end

  def validate_number(number, ary)
    raise "Wrong number!" if number >= ary.size || number.negative?
  end

  def choose_train
    trains_list(full: false)
    print 'Выберите порядковый номер поезда: '
    i = user_answer_to_i
    validate_number(i, trains)
    trains[i]
  end

  def choose_route
    routs_list
    print 'Выберите номер маршрута: '
    i = user_answer_to_i
    validate_number(i, routs)
    routs[i]
  end

  def choose_station
    stations_list(full: false)
    print 'Выберите порядковый номер станции: '
    i = user_answer_to_i
    validate_number(i, stations)
    stations[i]
  end

  def choose_wagon
    wagons_list
    print 'Введите номер вагона: '
    i = user_answer_to_i
    validate_number(i, wagons)
    wagons[i]
  end

  # Action functions -------------------------------------------------------------------------

  def add_station(route)
    station = choose_station
    i = route.ring? ? route.stations.size : route.stations.size - 1
    route.add_station(station, i)
  end

  def delete_station(route)
    if route.stations_to_delete?
      route_info(route)
      print 'Выберите номер станции, которую нужно удалить: '
      i = gets.to_i
      route.delete_station(route.stations[i])
    else
      print 'Из маршрута нельзя удалять станции!'
    end
  end

  def station_to_route
    route = choose_route
    print 'Что будем делать: добавлять (1) или удалять (0) станции из маршрута?: '
    operation = gets.to_i
    case operation
    when 0
      delete_station(route)
    when 1
      add_station(route)
    end
  rescue RuntimeError => e
    puts e.message
  end

  def wagon_to_train
    train = choose_train
    print 'Что будем делать: прицеплять (1) или отцеплять (0) вагон от поезда?: '
    operation = gets.to_i
    case operation
    when 0
      if !train.wagons.size.zero?
        train.detach_wagon(train.wagons.last)
      else
        print 'К этому поезду не прицеплено ни одного вагона! '
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

  def move_forward(train)
    puts "Train #{train.number} departure at '#{train.station.name}' station."
    train.go_forward
    puts "Train #{train.number} arrive at '#{train.station.name}' station."
  end

  def move_back(train)
    puts "Train #{train.number} departure at '#{train.station.name}' station."
    train.go_back
    puts "Train #{train.number} arrive at '#{train.station.name}' station."
  end

  def move_train
    train = choose_train
    loop do
      print 'Ехать вперед (1), ехать назад (-1), выйти в меню (0): '
      answer = gets.to_i
      case answer
      when 1
        move_forward(train)
      when -1
        move_back(train)
      when 0
        break
      end
    rescue RuntimeError => e
      puts e.message
      retry
    end
  end

  def add_volume(wagon)
    case wagon.type
    when :passenger
      wagon.take_place
    when :cargo
      print 'Введите объем, которые загружаем: '
      vol = gets.to_i
      wagon.upload(vol)
    end
  end

  def delete_volume(wagon)
    case wagon.type
    when :passenger
      wagon.free_place
    when :cargo
      print 'Введите объем, которы убираем: '
      vol = gets.to_i
      wagon.unload(vol)
    end
  end

  def volume_to_wagon
    wagon = choose_wagon
    print 'Бдем добавлять(1) или убирать (0) из вагона? '
    answer = gets.to_i
    case answer
    when 0
      delete_volume(wagon)
    when 1
      add_volume(wagon)
    end
  rescue RuntimeError => e
    puts e.message
    retry
  end
  # Menu  ----------------------------------------------------------------------------------------

  def create_menu
    loop do
      answer = gets.to_i
      answer.zero? ? break : public_send(@@create[answer])

      print 'Введите следующую команду (5 - текущее меню, 0 - основное меню): '
    end
  end

  def operations_menu
    loop do
      answer = gets.to_i
      answer.zero? ? break : public_send(@@operations[answer])

      print 'Введите следующую команду (6 - текущее меню, 0 - основное меню): '
    end
  end

  def info_menu
    loop do
      answer = gets.to_i
      answer.zero? ? break : public_send(@@info[answer])

      print 'Введите следующую команду (5 - текущее меню, 0 - основное меню): '
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
    end
  end
end
