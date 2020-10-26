# Заполнить хэш гласными буквами, где значением будет являться порядковый номер буквы в алфавите

vowel_arr = ['а', 'е', 'ё', 'и', 'о', 'у', 'ы', 'э', 'ю', 'я']

vowel_hash = {}

('а'..'я').each.with_index(1) {|letter, index| vowel_hash[letter] = index if vowel_arr.include? letter}

puts vowel_hash
