require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Dovado::Utilities do
  it "converts strings to symbols" do
    expect(Dovado::Utilities.name_to_sym("key name with spaces")).to eq :key_name_with_spaces
  end
end

describe Dovado::Router do
  @router = nil
  before(:context) do
    @router = Dovado::Router.new(address: '192.168.0.1', user: 'admin', password: 'password')
  end

  it "connects to a given router" do
    expect(@router).to be_a Dovado::Router
  end
  
  it "checks the router for info" do
    expect(@router.info).to_not be_nil
    expect(@router.info.local_ip).to eq '192.168.0.1'
    expect(@router.info).to_not be_nil
  end
  
  it "checks the router for services" do
    expect(@router.services).to_not be_nil
  end
  
  it "checks the router for sms" do
    expect(@router.sms).to_not be_nil
    @router.sms.load_messages
  end
end

describe Dovado::Router::Info::Operator::Telia do
  it "has commands" do
    operator = Dovado::Router::Info::Operator::Telia.new
    expect(operator.number).to be_a String
    expect(operator.commands).to_not be_nil
  end
end