class Inclusion

  attr_reader :word, :burb

  ALL = []

  def initialize(word, burb)
    @word = word
    @burb = burb
    ALL << self
  end

  def self.all
    ALL
  end

  def self.clear_all
    ALL.clear
  end

end