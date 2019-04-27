describe Word do

  after(:each) do
    Inclusion.clear_all
    Word.clear_all
    Burb.clear_all
  end

  describe "#==" do

    it "matches case insensitively" do
      expect(Word.new("FoO")).to eq(Word.new("fOo"))
    end

  end

  describe "#syllables" do

    it "returns the component syllables of the word" do
      expect(Word.new("Nor•ridge").syllables).to eq([:nor, :ridge])
    end

  end

  describe ".new" do

    it "creates a new word" do
      expect(Word.all).to eq([])
      @oak_title = Word.new("Oak")
      expect(Word.all.length).to be(1)
      expect(Word.all.first).to be(@oak_title)
      expect(@oak_title.to_s).to eq("oak") #downcased
    end
    
    it "returns a previously created word without duplicating it" do
      expect(Word.all).to eq([])
      @oak_title = Word.new("Oak")
      @oak_title_2 = Word.new("Oak")
      expect(@oak_title).to be(@oak_title_2)
      expect(Word.all.length).to be(1)
      expect(Word.all.last).to be(@oak_title)
    end

    it "matches case insensitively without duplicating a differently cased word" do
      expect(Word.all).to eq([])

      @oak_title = Word.new("Oak")
      @oak_emo = Word.new("oak")
      @oak_screamo = Word.new("OAK")

      expect(@oak_title).to be(@oak_emo)
      expect(@oak_title).to be(@oak_screamo)
      expect(@oak_emo).to be(@oak_screamo)
      
      expect(Word.all.length).to be(1)
      expect(Word.all.last).to be(@oak_title)
    end
    
  end

  describe "#embedded" do
    it "returns any previously-appearing words that are embedded in this word" do
      ridgewood = Word.new("Ridgewood")
      wood = Word.new("Wood")
      expect(ridgewood.embedded).to eq([ wood ])
    end
  end

  describe "#embedded" do
    it "returns any previously-appearing words that are embedded in this word" do
      ridgewood = Word.new("Ridgewood")
      wood = Word.new("Wood")
      expect(wood.containers).to eq([ ridgewood ])
    end
  end

  describe "#burbs" do

    before do
      @op = Burb.new("Oak Park")
      @ol = Burb.new("Oak Lawn")
      @norridge = Burb.new("Norridge")
      @park_ridge = Burb.new("Park Ridge") #this is a good order, because this way the word ridge is created after the word norridge
    end

    it "returns the burbs containing a word discretely" do
      expect(Word.new("Oak").burbs).to eq([@op, @ol])
    end

    it "returns the burbs containing an embedded word" do
      expect(Word.new("Ridge").burbs).to eq([@norridge, @park_ridge])
    end

  end

  describe ".shared" do
    it "returns the words that are shared by multiple suburbs" do
      @rf = Burb.new("River Forest")
      @fp = Burb.new("Forest Park")

      expect(Word.shared).to eq([ Word.new("Forest") ])
    end
  end

  describe "#non_word_syllables" do
    it "returns syllables, but only those that are not already words" do
      Word.new("Ridge")
      norridge = Word.new("Nor•ridge")
      expect(norridge.non_word_syllables).to eq([:nor])
    end

  end
  describe ".syllables_usage" do
    it "returns the syllables that are shared by multiple words, but are not words" do
      @rose = Word.new("Rose")
      @lemont = Word.new("Le•mont")
      @rosemont = Word.new("Rose•mont")

      expect(Word.non_word_syllables_usage).to eq({
        mont: [@lemont, @rosemont],
        le: [@lemont],
      })
    end
  end

  describe ".possible_words_from_syllables" do
    it "excludes only once-used syllables" do
      @rosemont = Word.new("Rose•mont")
      expect(Word.possible_words_from_syllables).to eq({})
      @montrose = Word.new("Mont•rose")
      expect(Word.possible_words_from_syllables).to eq({
        rose: [ @rosemont, @montrose ],
        mont: [ @rosemont, @montrose ]
      })
    end

    it "excludes one-letter syllables" do
      @hanover = Word.new("Han•o•ver")
      @hickory = Word.new("Hick•o•ry")
      expect(Word.possible_words_from_syllables).to eq({})
    end

    it "excludes a syllable that occurs no more often than an existing word that contains it" do
      @country = Word.new("Coun•try")
      @countryside = Word.new("Coun•try•side")
      expect(Word.possible_words_from_syllables).to eq({})
    end

  end

  describe "#appearances_in_lexicon" do 
    it "returns the number of times a word appears in other words, including itself" do
      @country = Word.new("Coun•try")
      @countryside = Word.new("Coun•try•side")
      expect(@country.appearances_in_lexicon).to be(2)
      expect(@countryside.appearances_in_lexicon).to be(1)
    end
  end

end