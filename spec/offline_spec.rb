require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Dovado::Utilities do
  it "converts strings to symbols", offline: true do
    expect(Dovado::Utilities.name_to_sym("key name with spaces")).to eq :key_name_with_spaces
  end
  it "converts arrays to sentences", offline: true do
    expect(Dovado::Utilities.array_to_sentence([1])).to eq "1"
    expect(Dovado::Utilities.array_to_sentence([1,2])).to eq "1 and 2"
    expect(Dovado::Utilities.array_to_sentence([1,2,3])).to eq "1, 2 and 3"
    expect(Dovado::Utilities.array_to_sentence([1,2,3,4])).to eq "1, 2, 3 and 4"
  end
end

describe Dovado::Router do
  @router = nil
  before(:context) do
    @router = Dovado::Router.new(address: '192.168.0.1', user: 'admin', password: 'password')
  end

  it "can be represented as a Router object", offline: true do
    expect(@router).to be_a Dovado::Router
  end
end

describe Dovado::Router::Info::Operator::Telia do
  before(:context) do
    @operator = Dovado::Router::Info::Operator::Telia.new
  end
  it "has commands", offline: true do
    expect(@operator.commands).to_not be_nil
    expect(@operator.commands).to be_a Hash
  end
  it "has a name", offline: true do
    expect(@operator.name).to be_a String
  end
  it "has a number", offline: true do
    expect(@operator.number).to be_a String
  end
end