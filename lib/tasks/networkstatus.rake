# -*- ruby -*-

require 'linux/netlink/route'
require 'open3'

#
# ultimately, this rake tasks is intended to start an ActionJob handler, perhaps as root,
# that can be provoked into doing some network tests, and network configurations.
#
# Perhaps setuid /sbin/ping will be enough in the end, we'll see.

namespace :dawnboot do
  desc "perform a network connectivity test, storing the results"
  task :network_connectivity_test => :environment do

    ip = Linux::Netlink::Route::Socket.new
    # find the (default) route to 8.8.8.8, and then ping that IP address.

    ns = DawnBoot::Networkstatus.new
    ns.inprogress = true
    ns.save

    defipv4 = ip.route.get(:dst=>"8.8.8.8")
    #puts "IPv4 default: #{defipv4.gateway}"

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

    ns.success = exitv4_status or exitv6_status
    ns.inprogress = false
    ns.testresults = { :v4_defroute => resultv4,
                       :v6_defroute => resultv6 }
    ns.save!
  end

end

