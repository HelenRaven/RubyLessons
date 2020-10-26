# Заданы три числа, которые обозначают число, месяц и год (запрашиваем у пользователя)
# Найти порядковый номер даты, начиная отсчет с начала года.
# Учесть, что год может быть високосным

def is_leap (year)
  return (year % 4 == 0 && year % 100 != 0) || (year % 100 == 0 && year % 400 == 0)
end

year_arr = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

year = 0
while year <= 0 do
  puts "Введите год:"
  year = gets.to_i
end

leap = is_leap(year)
year_arr[1] = 29 if leap

month = 0
while month <=0 || month > 12 do
  puts "Введите порядковый номер месяца (1-12):"
  month = gets.to_i
end

days_in_month = year_arr[month - 1]

date = 0
while date <=0 || date > days_in_month
    puts "Введите число месяца (в этом месяце #{days_in_month} дней):"
    date = gets.to_i
end

number = year_arr.take(month - 1).sum
number = number + date

puts "#{year}.#{month}.#{date} это #{number} день года."
