require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Dovado::Router do
  @router = nil
  before(:context) do
    @router = Dovado::Router.new(address: '192.168.0.1', user: 'admin', password: 'password')
  end

  it "can check the router for info", online: true do
    router_info = @router.info
    expect(router_info).to_not be_nil
    router_info.keys.each do |key|
      expect(router_info[key]).to_not be_nil
    end
  end
  
  it "can check the router for available services", online: true do
    router_services = @router.services
    expect(router_services).to_not be_nil
  end
  
  it "can check the router for text messages", online: true do
    router_sms = @router.sms
    expect(router_sms).to_not be_nil
  end
end
