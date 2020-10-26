#Заполнить массив числами Фибоначчи до 100

fibonacci = [1]

i = 0

next_f = 1

while next_f <= 100 do
  fibonacci << next_f
  next_f = fibonacci[i] + fibonacci[i + 1]
  i += 1
end

puts fibonacci

