require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Dovado::Router do
  @router = nil
  before(:context) do
    address   = ENV['ROUTER_ADDRESS']   ? ENV['ROUTER_ADDRESS']   : '192.168.0.1'
    user      = ENV['ROUTER_USER']      ? ENV['ROUTER_USER']      : 'admin'
    password  = ENV['ROUTER_PASSWORD']  ? ENV['ROUTER_PASSWORD']  : 'password'
    @router = Dovado::Router.new(address: address, user: user, password: password)
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

  it "can check the data traffic amounts", online: true do
    router_traffic = @router.traffic
    traffic_up = nil
    traffic_down = nil
    if router_traffic.up.is_a? Dovado::Router::Traffic::Amount
      traffic_up = router_traffic.up
      traffic_down = router_traffic.down
    elsif router_traffic.up.is_a? Array
      traffic_up = router_traffic.up.first
      traffic_down = router_traffic.down.first
    end
    expect(traffic_up).to be_a Dovado::Router::Traffic::Amount
    expect(traffic_down).to be_a Dovado::Router::Traffic::Amount
    expect(traffic_up.bytes).to be_a Integer
    expect(traffic_down.bytes).to be_a Integer
    expect(traffic_up.kilobytes).to be_a Integer
    expect(traffic_down.kilobytes).to be_a Integer
    expect(traffic_up.megabytes).to be_a Float
    expect(traffic_down.megabytes).to be_a Float
    expect(traffic_up.gigabytes).to be_a Float
    expect(traffic_down.gigabytes).to be_a Float
  end
end
