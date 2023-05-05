require 'linux/netlink/route'
require 'open3'

class DawnBoot::Networkstatus < ApplicationRecord

  def self.most_recent
    order(:updated_at => "DESC").first
  end

  def gather_data
    ip = Linux::Netlink::Route::Socket.new

    # find the (default) route to 8.8.8.8, and then ping that IP address.
    defipv4 = ip.route.get(:dst=>"8.8.8.8")

    results = ''
    exit_status = 0
    stdin, stdout, wait_thr = Open3.popen2e('/bin/ping','-4','-c','2', defipv4.gateway.to_s)
    resultv4 = stdout.read.chomp
    exitv4_status = wait_thr.value # Process::Status object returned.
    #puts "Returns #{exitv4_status}: #{resultv4}"

    defipv6 = ip.route.get(:dst=>"2001:4860:4860::8844")
    #puts "IPv6 default: #{defipv6.gateway} % #{defipv6.oif}"

    stdin, stdout, wait_thr = Open3.popen2e('/bin/ping','-6','-c','2', "#{defipv6.gateway.to_s}%#{defipv6.oif}")
    resultv6 = stdout.read.chomp
    exitv6_status = wait_thr.value # Process::Status object returned.
    #puts "Returns #{exitv6_status}: #{resultv6}"

    self.success = exitv4_status or exitv6_status

    public_ip4=[]
    public_ip6=[]
    # now get list of public IPv4s, and IPv6 GUA and ULAs.
    ip.addr.list.each { |addr|
      next if (addr.label == 'lo' || addr.index == 1)
      case addr.family
      when 2     # IPv4
        next if addr.address.private?    # RFC1918 won't work in DNS.
        next if addr.address.link_local?
        public_ip4 << addr.address
      when 10    # IPv6
        next if addr.address.link_local?
        # .private? says true for ULA, but we want them
        public_ip6 << addr.address
      end
    }

    self.testresults = { :v4_defroute => resultv4,
                         :v6_defroute => resultv6,
                         :v4_addrs => public_ip4,
                         :v6_addrs => public_ip6
                       }


    self.inprogress = false
    save!
  end
end
