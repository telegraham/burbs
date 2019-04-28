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

    it "raises an exception only when the syllable splits don't match a cached word" do
      Word.new("Ha•zel")
      expect { Word.new("Ha•zel") }.not_to raise_error
      expect { Word.new("Hazel") }.to raise_exception(ArgumentError, /syllable/i)
      
      Word.new("River")
      expect { Word.new("River") }.not_to raise_error
      expect { Word.new("Ri•ver") }.to raise_exception(ArgumentError, /syllable/i)

      Word.new("Fo•rest")
      expect { Word.new("Fo•rest") }.not_to raise_error
      expect { Word.new("Fo•Rest") }.not_to raise_error
      expect { Word.new("For•est") }.to raise_exception(ArgumentError, /syllable/i)
    end
    
  end

  describe "#embedded" do
    it "returns any previously-appearing words that are embedded in this word as syllables" do
      ridgewood = Word.new("Ridge•wood")
      wood = Word.new("Wood")
      expect(ridgewood.embedded).to eq([ wood ])
    end

    it "returns any previously-appearing words composed of multiple syllables" do
      riverside = Word.new("Ri•ver•side")
      river = Word.new("Ri•ver")
      expect(riverside.embedded).to eq([ river ])
    end

    it "ignores words that don't split on syllable boundaries" do
      Word.new("Des")
      plaines = Word.new("Plaines")
      Word.new("La")
      Word.new("Grange")
      expect(plaines.embedded).to eq([]) #not [ "la" ]
    end
  end

  describe "#embedded" do
    it "returns any previously-appearing words that are embedded in this word" do
      ridgewood = Word.new("Ridge•wood")
      wood = Word.new("Wood")
      expect(wood.containers).to eq([ ridgewood ])
    end
  end

  describe "#burbs" do

    before do
      @op = Burb.new("Oak Park")
      @ol = Burb.new("Oak Lawn")
      @norridge = Burb.new("Nor•ridge")
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

  describe "#has_burbs_besides?" do

    before do
      @oak = Burb.new("Oak Park")
      @forest = Burb.new("Forest Park")
    end

    it "returns false if the word belongs to only the burb passed in" do
      expect(Word.new("Oak").has_burbs_besides? @oak).to be(false)
    end

    it "returns true if the word belongs to a burb besides the argument" do
      expect(Word.new("Park").has_burbs_besides? @forest).to be(true)
    end

  end


  describe "uses" do

    before do
      @oak_park = Burb.new("Oak Park")
      @forest_park = Burb.new("Forest Park")
      @river_forest = Burb.new("River Forest")
      @riverside = Burb.new("River•side")
    end

    it "returns the number of burbs which use this word" do
      expect(Word.new("Oak").uses).to eq(1)
      expect(Word.new("Forest").uses).to eq(2)
      expect(Word.new("Park").uses).to eq(2)
    end

    it "returns the number of burbs which use this word as a fragment" do
      expect(Word.new("River").uses).to eq(2)
    end

    # this shouldn't work
    # it "returns the number of usages for a remainder word" do
    #   expect(Word.new("Side").uses).to eq(1)
    # end

  end

  describe "used_more_than_embedded?" do

    before do
      Burb.new("Riv•er For•est")
      Burb.new("Riv•er•side")
      Burb.new("North Riv•er•side")
      Burb.new("North•brook")
      Burb.new("North•field")
      Burb.new("North•lake")
    end

    it "returns false if the word is used less often than the sum of its embedded words' usages" do
      expect(Word.new("North•lake").used_more_than_embedded?).to be(false)
    end

    it "returns false if the word is as often as the sum of its embedded words' usages" do

    end

    it "returns true if the word has no embedded words" do
      expect(Word.new("North").used_more_than_embedded?).to be(true)
    end

    it "returns true if the word is used more often than the sum of its embedded words" do
      expect(Word.new("Riv•er•side").used_more_than_embedded?).to be(true)
    end

  end

  describe "#decompose" do
    before(:each) do
      @riverside = Word.new("Riv•er•side")
    end

    after(:each) do
      Word.clear_all
    end

    it "returns an array of strings with a left edge embed" do
      Word.new("Riv•er")
      expect(@riverside.decompose).to eq([ Word.new("Riv•er"), "side" ])
    end

    it "returns an array of strings with a right edge embed" do
      Word.new("Side")
      expect(@riverside.decompose).to eq([ "river", Word.new("side") ])
    end

    it "returns an array of strings with all embeds" do
      Word.new("Riv•er")
      Word.new("Side")
      expect(@riverside.decompose).to eq([ Word.new("riv•er"), Word.new("side") ])
    end
    
    it "returns an array of strings with a middle embed" do
      @riverside = Word.new("Di•vers•i•ty")
      Word.new("vers")
      expect(@riverside.decompose).to eq([ "di", Word.new("vers"), "ity" ])
    end
    it "returns an array of strings with complex embeddings" do
      @riverside = Word.new("Di•ve•rsi•ty")
      Word.new("ve")
      Word.new("ty")
      expect(@riverside.decompose).to eq([ "di", Word.new("ve"), "rsi", Word.new("ty") ])
    end
  end

end