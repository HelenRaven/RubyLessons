# Заполнить хэш гласными буквами, где значением будет являться порядковый номер буквы в алфавите

vowel_arr = ['а', 'е', 'ё', 'и', 'о', 'у', 'ы', 'э', 'ю', 'я']

vowel_hash = Hash.new

i = 1

for letter in 'а'..'я'
	if vowel_arr.include? letter
		vowel_hash[letter] = i
	end
	i += 1
end

puts vowel_hash
