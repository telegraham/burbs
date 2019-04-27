require_relative 'environment'

names = CSV.foreach("syllaburbs.csv").map do |row|
  row.first
end

burbs = names.uniq.map do |name|
  Burb.new(name)
end


# burbs_hash = burbs.reduce({}) do |accumulator, burb|
#   burb.words.each do |word|
#     accumulator[word] ||= []
#     accumulator[word] << burb
#   end
#   accumulator
# end

# all_words = burbs_hash.keys.map(&:downcase)

# p burbs_hash

# p all_words.include? "dale"


# def split_word_into_chunks_of_size(size, word)
#   chunks = (word.length - size + 1).times.map do |start_index|
#     # binding.pry
#     word[start_index..(size + start_index)]
#   end
# end

# fragments = all_words.reduce({}) do |accumulator, word| 
#   max_fragment_size = word.length - 1
#   (3..max_fragment_size).each do |length|
#     split_word_into_chunks_of_size(length, word).each do |chunk|
#       accumulator[chunk] ||= 0
#       accumulator[chunk] += 1
#     end
#   end
#   accumulator
# end

# inverted_fragments = fragments.reduce({}) do |accumulator, kvp|
#   key = kvp.first
#   value = kvp.last

#   accumulator[value] ||= []
#   accumulator[value] << key
#   accumulator
# end 

# p inverted_fragments


# embedded = ["wood", "field", "view", "side", "north", "ridge"]
# maybe = ["ton", "ington"]
# no = ["land", "rest"]

# binding.pry

# p all_words.map(&:downcase).include? "dale"






