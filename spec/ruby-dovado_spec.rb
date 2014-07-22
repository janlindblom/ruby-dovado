require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Dovado::Router do
  @router = nil
  
  it "connects to a given router" do
    @router = Dovado::Router.new(address: '10.0.1.1')
    @router.connect.should be true
    @router.disconnect.should be true
  end
  
  it "checks the router for info" do
    @router = Dovado::Router.new(address: '10.0.1.1')
    puts @router.info.inspect
  end
end

describe Dovado::Router::Info::Operator::Telia do
  it "has commands" do
    operator = Dovado::Router::Info::Operator::Telia.new
    puts operator.inspect
  end
end