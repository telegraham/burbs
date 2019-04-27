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
      expect(@norridge.words).to match_array([Word.new("Ridge"), Word.new("Norridge")])
    end

  end

  describe ".all" do

    it "returns an array of all the burbs" do
      expect(Burb.all).to eq([ @op, @norridge ])
    end

  end

end