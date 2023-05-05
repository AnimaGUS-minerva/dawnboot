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

    ns = DawnBoot::Networkstatus.new
    ns.inprogress = true
    ns.save
    ns.gather_data
  end

end

