
class Word < String

  ALL = {}

  attr_reader :syllables

  def self.new(text)
    downcased = text.downcase
    new_one = super(downcased)
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

