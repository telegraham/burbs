describe Burb do

  after(:each) do
    Inclusion.clear_all
    Word.clear_all
    Burb.clear_all
  end

  before do
    @op = Burb.new("Oak Park")
    @norridge = Burb.new("Nor•ridge")
  end

  describe "#words" do

    it "returns the component words of the burb" do
      expect(@op.words).to eq(["Oak", "Park"])
      expect(@norridge.words).to eq(["Norridge"])
    end

    it "returns embedded words of the burb based on previously defined words" do
      @pr = Burb.new("Park Ridge")
      expect(@norridge.words).to match_array([Word.new("Ridge"), Word.new("Nor•ridge")])
    end

  end

  describe "#uses_shared_word?" do

    before do
      @oak_park = Burb.new("Oak Park")
      @forest_park = Burb.new("Forest Park")
      @oak_forest = Burb.new("Oak Forest")
      @park_forest = Burb.new("Park Forest")
      @river_forest = Burb.new("River Forest")
      @park_ridge = Burb.new("Park Ridge")
      @naperville = Burb.new("Naperville")
    end

    it "returns false if the burb doesn't share a word with another" do
      expect(@oak_park.uses_shared_word?).to eq(true) 
      expect(@forest_park.uses_shared_word?).to eq(true) 
      expect(@oak_forest.uses_shared_word?).to eq(true) 
      expect(@park_forest.uses_shared_word?).to eq(true) 
      expect(@river_forest.uses_shared_word?).to eq(true) 
      expect(@park_ridge.uses_shared_word?).to eq(true) 
    end

    it "returns true if the burb shares a word with another" do
      expect(@naperville.uses_shared_word?).to eq(false) 
    end

  end

  describe ".sharing" do

    before do
      Burb.clear_all #override parent before
      @oak_park = Burb.new("Oak Park")
      @forest_park = Burb.new("Forest Park")
      @oak_forest = Burb.new("Oak Forest")
      @park_forest = Burb.new("Park Forest")
      @river_forest = Burb.new("River Forest")
      @park_ridge = Burb.new("Park Ridge")
      @naperville = Burb.new("Naperville")
    end


    it "returns only burbs that share words" do
      expect(Burb.sharing).to eq([
        @oak_park,
        @forest_park,
        @oak_forest,
        @park_forest,
        @river_forest,
        @park_ridge 
      ])
    end

  end

  describe "#to_edges" do
    it "returns edges for discrete words" do
      expect(@op.to_edges).to eq(["oak -> park"])
    end

    it "returns edges for embedded words and any remaining text" do
      @park_ridge = Burb.new("Park Ridge")
      expect(@norridge.to_edges).to eq(["nor -> ridge"])
    end

  end

  describe ".all" do

    it "returns an array of all the burbs" do
      expect(Burb.all).to eq([ @op, @norridge ])
    end

  end

end