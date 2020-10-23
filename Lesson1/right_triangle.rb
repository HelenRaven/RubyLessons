sides = []

3.times do |i|
  puts "Введите длину #{i + 1}й стороны треугольника:"
  sides[i] = gets.to_f
end

if sides.uniq.length == 1
  puts "Треугольник равносторонний (и по умолчанию - равнобедренный)"
else
# если треугольник не равносторонний, он может быть равнобедренным и/или прямоугольным
  if sides.uniq.length == 2
    puts "Треугольник равнобедренный"
  end

  h = sides.max
  katets = sides.reject{|x| x == h}
  k_sqware = 0

  katets.each {|katet| k_sqware = k_sqware + katet * katet}

  if h * h == k_sqware
    puts "Треугольник прямоугольный"
  end
end
