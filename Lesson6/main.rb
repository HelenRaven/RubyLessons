
require_relative 'railroad'


def menu
  puts"Введите команду: "
  puts" 1 - создать объект (станция, маршрут, поезд, вагон)."
  puts" 2 - операции с объектами."
  puts" 3 - вывести данные об объектах."
  puts" 4 - вывести меню."
  puts" 0 - закончить программу."
end

def menu_create
  puts"Введите команду: "
  puts" 1 - создать станцию."
  puts" 2 - создать маршрут."
  puts" 3 - создать поезд."
  puts" 4 - создать вагон"
  puts" 5 - вывести меню."
  puts" 0 - вернуться в предыдущее меню."
end

def menu_operations
  puts"Введите команду: "
  puts" 1 - добавить/удалить станции в маршрут."
  puts" 2 - добавить/отцепить вагоны к поезду."
  puts" 3 - установить маршрут поезда."
  puts" 4 - переместить поезд вперед/назад по маршруту."
  puts" 5 - вывести меню."
  puts" 0 - вернуться в предыдущее меню."
end

def menu_print
  puts"Введите команду : "
  puts" 1 - напечатать список станций / список поездов на станции."
  puts" 2 - напечатать список маршрутов / распечатать маршрут."
  puts" 3 - напечатать список поездов / информацию о поезде / маршрут поезда. "
  puts" 4 - напечатать список вагонов."
  puts" 5 - вывести меню."
  puts" 0 - вернуться в предыдущее меню."
end

def user_answer_to_i
  gets.to_i - 1
end

def create_menu (railroad)
  loop do
    answer = gets.to_i
    case answer
      # создать станцию
      when 1
        begin
          print"Введите название станции:"
          name = gets.chomp
          railroad.make_station(name)
        rescue RuntimeError => e
            puts e.message
        retry
        end

      # создать маршрут
      when 2
        if railroad.stations.size != 0
          railroad.print_stations
          print"Выберите номер начальной станции: "
          i = user_answer_to_i
          start = railroad.stations[i]

          print "Выберите номер конечной станции:"
          i = user_answer_to_i
          finish = railroad.stations[i]

          railroad.make_route(start,finish)
        else
          puts "Сначала создайте станции."
        end

      # создать поезд
      when 3
        begin
          print"Введите номер поезда: "
          number = gets.chomp
          print"Введите тип поезда (cargo/passenger): "
          type = gets.chomp.to_sym
          railroad.make_train(number, type)
          rescue RuntimeError => e
            puts e.message
          retry
        end

      # создать вагон
      when 4
        begin
          print"Введите тип вагона (cargo/passenger): "
          type = gets.chomp.to_sym
          railroad.make_wagon(type)
        rescue RuntimeError => e
          puts e.message
        retry
        end
      when 5
        menu_create
      when 0
        break
    end
    print "Введите следующую команду (5 - текущее меню, 0 - основное меню):"
  end
end

def operations_menu (railroad)
  loop do
    answer = gets.to_i
    case answer

      # добавить/удалить станцию в маршрут
      when 1
        railroad.print_routs
        print "Выберите маршрут:"
        i = user_answer_to_i

        print "Что будем делать: добавлять (1) или удалять (0) станции из маршрута?:"
        operation = gets.to_i

        case operation
          when 0
            if railroad.routs[i].have_stations_to_delete?
              railroad.routs[i].print_full
              print "Выберите номер станции, которую нужно удалить:"
              j = gets.to_i
              railroad.routs[i].delete_station(railroad.routs[i].stations[j])
            else
              print "Из эого маршрута нельзя удалять станции"
            end
          when 1
            railroad.print_stations
            print "Введите номер станции, которую будем добавлять в маршрут:"
            j = user_answer_to_i
            k = railroad.routs[i].is_ring ? railroad.routs[i].stations.size : railroad.routs[i].stations.size - 1
            railroad.routs[i].add_station(railroad.stations[j], k)
        end
        puts "Измененный маршрут:"
        railroad.routs[i].print_full

      # прицепить/отцепить вагон к поезду
      when 2
        railroad.print_trains
        print "Выберите порядковый номер поезда:"
        i = user_answer_to_i
        print "Что будем делать: прицеплять (1) или отцеплять (0) вагон от поезда?:"
        operation = gets.to_i

        case operation

          when 0
            if railroad.trains[i].wagons.size != 0
              railroad.trains[i].detach_wagon(railroad.trains[i].wagons.last)
            else
              print "К этому поезду не прицеплено ни одного вагона."
            end
          when 1
            railroad.print_wagons
            print "Введите номер вагона, который будем прицеплять к поезду:"
            j = user_answer_to_i
            railroad.trains[i].attach_wagon(railroad.wagons[j])
          end

      # установить маршрут поезда
      when 3
        railroad.print_trains
        print "Выберите порядковый номер поезда:"
        i = user_answer_to_i

        railroad.print_routs
        print "Выберите маршрут:"
        j = user_answer_to_i

        railroad.trains[i].get_route(railroad.routs[j])

      #переместить поезд вперед/назад по маршруту
      when 4
        railroad.print_trains
        print "Выберите порядковый номер поезда:"
        i = user_answer_to_i

        loop do
          print "Ехать вперед (1), ехать назад (-1), выйти в меню (0):"
          answer = gets.to_i

          case answer
            when 1
              railroad.trains[i].go_forward
            when -1
              railroad.trains[i].go_back
            when 0
              break
          end
        end

      when 5
        menu_operations
      when 0
        break
    end
    print"Введите следующую команду (5 - текущее меню, 0 - основное меню):"
  end
end

def info_menu (railroad)
  loop do
    answer = gets.to_i
    case answer
      # напечатать список станций / список поездов на станции.
      when 1
        railroad.stations.each {|station| station.print_trains}
      # напечатать список маршрутов / распечатать маршрут.
      when 2
        railroad.routs.each {|route| route.print_full}
      # напечатать список поездов / информацию о поезде / маршрут поезда.
      when 3
        railroad.trains.each {|train| train.info_full}
      # напечатать список вагонов
      when 4
        railroad.wagons.each {|wagon| wagon.info}
      when 5
        menu_print
      when 0
        break
    end
    print"Введите следующую команду (5 - текущее меню, 0 - основное меню):"
  end
end


railroad = RailRoad.new

=begin
s1 = railroad.make_station("Moscow")
s2 = railroad.make_station("Piter")
s3 = railroad.make_station("Kolomna")
s4 = railroad.make_station("Zavidovo")
s5 = railroad.make_station("Rameskoe")

w1 = railroad.make_wagon(:cargo)
w2 = railroad.make_wagon(:cargo)
w3 = railroad.make_wagon(:passenger)
w4 = railroad.make_wagon(:passenger)
w5 = railroad.make_wagon(:passenger)

t1 = railroad.make_train(12, :cargo)
t2 = railroad.make_train(25, :cargo)
t3 = railroad.make_train(132, :passenger)
t4 = railroad.make_train(256, :passenger)
=end

 loop do
  menu
  answer = gets.to_i

  case answer
    when 1
      menu_create
      create_menu(railroad)

    when 2
      menu_operations
      operations_menu(railroad)

    when 3
      menu_print
      info_menu(railroad)

    when 4
      menu

    when 0
      break
  end
  print"Введите следующую команду (4 - вывести меню снова):"
end
