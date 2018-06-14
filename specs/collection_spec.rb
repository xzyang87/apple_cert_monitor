require "set"

RSpec.shared_examples "a collection" do
  let(:collection) { described_class.new([7, 2, 4]) }

  context "initialized with 3 items" do
    it "says it has three items" do
      expect(collection.size).to eq(3)
    end
  end

  describe "#include?" do
    context "with an item that is in the collection" do
      it "returns true" do
        expect(collection.include?(7)).to be_truthy
      end
    end

    context "with an item that is not in the collection" do
      it "returns false" do
        expect(collection.include?(9)).to be_falsey
      end
    end
  end
end

RSpec.describe Array do
  it_behaves_like "a collection"
end

RSpec.describe Set do
  it_behaves_like "a collection"
end
