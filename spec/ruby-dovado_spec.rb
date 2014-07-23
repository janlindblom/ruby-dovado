require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Dovado::Utilities do
  it "converts strings to symbols" do
    Dovado::Utilities.name_to_sym("key name with spaces").should eq :key_name_with_spaces
  end
end

describe Dovado::Router do
  @router = nil
  
  it "connects to a given router" do
    @router = Dovado::Router.new(address: '10.0.1.1')
  end
  
  it "checks the router for info" do
    @router = Dovado::Router.new(address: '10.0.1.1')

    @router.info.local_ip.should eq '10.0.1.1'
    puts @router.info.inspect
  end
  
  it "checks the router for services" do
    @router = Dovado::Router.new(address: '10.0.1.1')
    puts @router.services.inspect
  end
  
  it "checks the router for sms" do
    @router = Dovado::Router.new(address: '10.0.1.1')

    puts @router.sms.enabled
    @router.sms.load_messages
    puts @router.sms.inspect
  end
end

describe Dovado::Router::Info::Operator::Telia do
  it "has commands" do
    operator = Dovado::Router::Info::Operator::Telia.new
    puts operator.inspect
  end
end