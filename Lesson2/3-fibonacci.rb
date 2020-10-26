#Заполнить массив числами Фибоначчи до 100

fibonacci = [1]

next_f = 1

while next_f <= 100 do
  fibonacci << next_f
  next_f = fibonacci[-1] + fibonacci[-2]
end

puts fibonacci
