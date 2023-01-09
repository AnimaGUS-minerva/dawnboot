require 'rails_helper'

RSpec.describe Netplan, type: :model do

  describe "network configuration" do
    it "should parse a sample file" do
      file="spec/files/netplan01.yml"
      n = Netplan.new
      n.rootdir="spec/files/host01"
      n.parse_file
      expect(n).to_not be_nil
      expect(n.attributes["network"]["ethernets"]["enp0s3"]["gateway4"]).to eq("192.168.2.1")
    end

    def canned_getifaddrs
    end

    it "should collect current active IP addresses" do
      n = Netplan.new
      n.ifaddrs(
      expect(n.interfaces).to_
    end
  end

  describe "hostname" do
    it "should read the hostname" do
      n = Netplan.new
      n.rootdir="spec/files/host01"
      expect(n.hostname).to eq("netplan01")
    end
  end

end

