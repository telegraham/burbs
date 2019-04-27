class SyllableUsage < Array

  attr_reader :syllable

  def initialize(syllable)
    @syllable = syllable
  end

  def possible_word
    is_longer_than_one_character && used_more_than_once && not_just_part_of_an_equally_common_word
  end

  private

  def is_longer_than_one_character
    syllable.length > 1
  end

  def used_more_than_once
    self.count > 1
  end

  def not_just_part_of_an_equally_common_word
    self.count > self.map(&:appearances_in_lexicon).max
  end

end