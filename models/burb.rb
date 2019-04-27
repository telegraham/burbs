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

