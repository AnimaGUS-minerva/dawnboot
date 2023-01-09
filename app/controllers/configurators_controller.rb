class ConfiguratorsController < ApplicationController

  def index
    setup
  end

  def start
    setup
  end

  private
  def setup
    @config = DawnBoot::Configuration.default
    @netplan = Netplan.new
    @netplan.ifaddrs(Socket.getifaddrs)
  end

end
