# Заданы три числа, которые обозначают число, месяц и год (запрашиваем у пользователя)
# Найти порядковый номер даты, начиная отсчет с начала года.
# Учесть, что год может быть високосным

def is_leap (year)
	if (year % 4 == 0 && year % 100 != 0) || (year % 100 == 0 && year % 400 == 0)
		return true
	else
		return false
	end
end

year_arr = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

year = 0
while year <= 0 do
	puts "Введите год:"
	year = gets.to_i
end

month = 0
while month <=0 || month > 12 do
	puts "Введите порядковый номер месяца (1-12):"
	month = gets.to_i
end

leap = is_leap(year)

if leap && month == 2
	days_in_month = 29
else
	days_in_month = year_arr[month - 1]
end

date = 0
while date <=0 || date > days_in_month
		puts "Введите число месяца (в этом месяце #{days_in_month} дней):"
		date = gets.to_i
end

number = 0
for i in (0..(month - 2))
	number = number + year_arr[i]
end

number = number + date

if leap && month > 2
	number += 1
end

puts "#{year}.#{month}.#{date} это #{number} день года."
