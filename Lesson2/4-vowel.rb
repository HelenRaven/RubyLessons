# Заполнить хэш гласными буквами, где значением будет являться порядковый номер буквы в алфавите

vowel_arr = ['а', 'е', 'ё', 'и', 'о', 'у', 'ы', 'э', 'ю', 'я']

vowel_hash = Hash.new

('а'..'я').each.with_index(1) { |value, index| vowel_hash[value] = index if vowel_arr.include? value}

puts vowel_hash
