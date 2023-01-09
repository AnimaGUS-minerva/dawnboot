require 'rails_helper'

RSpec.describe Netplan, type: :model do

  def setup_netplan
    n = Netplan.new
    n.rootdir="spec/files/host01"
    n.parse_file  # /etc/netplan/01-netplan.yml
    n
  end

  describe "network configuration" do
    it "should parse a sample file" do
      n = setup_netplan
      expect(n).to_not be_nil
      expect(n.attributes["network"]["ethernets"]["enp0s3"]["gateway4"]).to eq("192.168.2.1")
    end


    it "should collect current active IP addresses" do
      n = setup_netplan
      n.ifaddrs(Socket.getifaddrs)
      expect(n.active_interfaces).to_not be_nil
    end
  end

  describe "hostname" do
    it "should read the hostname" do
      n = setup_netplan
      n.rootdir="spec/files/host01"
      expect(n.hostname).to eq("netplan01")
    end
  end

end

