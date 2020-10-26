
name = ""
purchases = Hash.new

loop do
  puts "Введите название товара (для завершения введите 'стоп'):"
  name = gets.chomp

  break if name == "стоп"

  puts "Введите количество товара:"
  amount = gets.to_f

  puts"Введите цену товара:"
  price = gets.to_f

  if purchases[name] == nil
    purchases[name] = {price => amount}
  else
    if purchases[name][price] == nil
      purchases[name][price] = amount
    else
      purchases[name][price] = purchases[name][price] + amount
    end
  end
end

puts purchases

final = 0
purchases.each do |key, value|
  print "Общая стоимость товара #{key} = "
  total = 0
  value.each do |price, amount|
    total = total + price * amount
  end
  print "#{total} \n"
  final = final + total
end

puts "Общая сумма покупок: #{final}"
