puts "Как вас зовут?"
name = gets.chomp.capitalize

puts "Ваш рост (в сантиметрах)?"
height = gets.to_i

ideal_weight = (height - 110) * 1.15

if ideal_weight > 0
  puts "#{name}, ваш идеальный вес #{ideal_weight} кг."
else
  puts "#{name}, ваш вес оптимальный."
end
