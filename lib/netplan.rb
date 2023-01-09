
class Netplan
  attr_accessor :attributes
  attr_accessor :hostname
  attr_accessor :rootdir

  class Interface
    attr_accessor :name
    attr_accessor :ipv4
    attr_accessor :ipv6
    attr_accessor :hwaddr
  end

  def rootdir
    @rootdir || ''
  end

  def parse_file(file = "/etc/netplan/01-netplan.yml")
    file = File.open(file)
    parse_yaml(file.read)
  end

  def parse_yaml(yaml)
    @attributes = YAML::load(yaml)
  end

  def hostname
    @hostname ||= File.read(File.join(rootdir,"/etc/hostname")).chomp || Socket.gethostname
  end

  def parse_ifaddrs
    @interfaces = []
    @byifname   = Hash.new
    @byifindex  = Hash.new
    @ifaddrslist.each do |ifn|
      @interfaces << ifn.name
      @byifname[ifn.name] = ifn
      @byifindex[ifn.ifindex] = ifn
    end
  end

  def ifaddrs(ifaddrslist)
    @ifaddrslist = ifaddrslist
    parse_ifaddrs
  end

  def interface_names
    @interfaces
  end

  def active_interfaces
    active = Hash.new
    @byifname.each { |name, ifaddr|
      if ifaddr.flags & Socket::IFF_UP
        ifn = (active[name] ||= Interface.new)
        ifn.name = name
        if ifaddr.addr && ifaddr.addr.pfamily == 2 && ifaddr.addr.ipv4?
            ifn.ipv4 = ifaddr.addr.ip_address
        end
        if ifaddr.addr && ifaddr.addr.pfamily == 10 && ifaddr.addr.ipv6?
            ifn.ipv6 = ifaddr.addr.ip_address
        end
      end
    }
    active
  end

end
