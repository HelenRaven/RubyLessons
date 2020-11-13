# frozen_string_literal: true

require_relative 'wagon'
require_relative 'train'
require_relative 'station'
require_relative 'route'

def wagon_info(wagon)
  puts "Train number = #{wagon.train_number}"
  puts "Train number history = #{wagon.train_number_history}"
  puts "Wagon attached to train? #{wagon.attached?}"
  puts "-" * 50
end

w1 = Wagon.new(100)
wagon_info(w1)

w1.train_number = '12345'
wagon_info(w1)

w1.train_number = 'kkkkk'
wagon_info(w1)

begin
  t = Train.new('ggg-12')
  puts "Train number = #{t.number}"

  # t1 = Train.new("kk")

  # t2 = Train.new(12345)

  # s1 = Station.new(123)
rescue RuntimeError => e
  puts e.message
end
