class Burb < String

  ALL = {}

  def initialize(name)
    words = name.split(/\s/).map do |name|
      Word.new(name)
    end

    words.each do |word|
      Inclusion.new(word, self)
    end

    super(words.join(" ").titleize)

    ALL[name] = self
  end
  
  def words
    embedded_words + discrete_words
  end

  def inspect
    "#<#{ self.class.name}:#{ self }>"
  end

  def self.all
    ALL.values
  end

  def self.clear_all
    ALL.clear
  end

  def self.first
    all.first
  end

  def self.last
    all.last
  end

  def uses_shared_word?
    words.any? do |word|
      word.has_burbs_besides? self
    end
  end

  def self.sharing
    all.select do |burb|
      burb.uses_shared_word?
    end
  end

  def to_edges
    # binding.pry
    words = self.words
    words_count = words.count
    edges = []
    words.each_with_index do |word, index|
      if index < words_count - 1
        edges << "#{ word } -> #{ words[index + 1] }"
      end
    end
    edges
  end

  private

  def embedded_words
    discrete_words.map(&:embedded).flatten
  end

  def discrete_words
    inclusions.map(&:word)
  end

  def inclusions
    Inclusion.all.select do |inclusion|
      inclusion.burb == self
    end
  end

end

