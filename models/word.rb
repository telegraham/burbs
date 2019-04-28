
class Word < String

  ALL = {}

  attr_reader :syllables

  def self.new(text)
    downcased = text.downcase
    new_one = super(downcased)
    cached = ALL[new_one]
    if cached && new_one.syllables != cached.syllables
      raise ArgumentError.new("Syllable splits must match cached!") 
    end
    ALL[new_one] ||= new_one
  end

  def initialize(text)
    text = text.downcase #just in cases
    @syllables = text.split("•").map(&:to_sym)
    super(text.gsub("•", ""))
  end

  def ==(value)
    # this should both be case insensitive
    # and compare based on the letters, not object id
    self.downcase.to_sym == value.downcase.to_sym
  end

  def hash
    # downcase just in case
    self.downcase.to_sym.hash
  end

  def burbs
    burbs_from_containing_words + burbs_from_inclusions
  end

  def inspect
    "#<#{ self.class.name }:#{ self.to_s }>"
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

  def self.shared
    all.select do |word|
      word.burbs.count > 1
    end
  end

  def non_word_syllables
    syllables - Word.all.map(&:to_sym)
  end

  def self.non_word_syllables_usage
    Word.all.reduce({}) do |accumulator, word|
      word.non_word_syllables.map do |syllable|
        accumulator[syllable] ||= SyllableUsage.new(syllable)
        accumulator[syllable] << word
      end
      accumulator
    end
  end

  def self.possible_words_from_syllables
    Word.non_word_syllables_usage.select do |key, syllable_usage|
      syllable_usage.possible_word
    end
  end

  def appearances_in_lexicon
    Word.all.count do |word|
      word.include? self
    end
  end

  def embedded
    Word.all.select do |word|
      self != word && self.include?(word)
    end
  end

  def containers
    Word.all.select do |word|
      self != word && word.include?(self)
    end
  end

  def has_burbs_besides?(burb_arg)
    burbs.any? do |burb|
      burb != burb_arg
    end
  end

  def uses
    burbs.count
  end

  def used_more_than_embedded?
    uses > (embedded.map(&:uses).sum - uses) #maybe mean?
  end

  def decompose
    embedded.sort_by do |embed|
      self.index embed
    end.reduce([self.to_s]) do |accumulator, embed|
      remainder = accumulator.pop
      embed_index = remainder.index embed
      unless embed_index == 0
        accumulator << remainder[0...embed_index] # push non-word chunk on
      end
      accumulator << embed #push the embed on
      remainder = remainder[(embed_index + embed.length)...remainder.length]
      if remainder.length > 0
        accumulator << remainder
      end
      accumulator
    end
  end

  private

  def burbs_from_containing_words
    containers.map(&:burbs).flatten
  end

  def burbs_from_inclusions
    inclusions.map(&:burb)
  end

  def inclusions
    Inclusion.all.select do |inclusion|
      inclusion.word == self
    end
  end

end

