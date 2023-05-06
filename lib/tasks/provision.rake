# -*- ruby -*-

namespace :dawnboot do
  desc "do initial onboarding with EMAIL=foo@example.com"
  task :onboard_with_email => :environment do

    Rails.logger = Logger.new(STDOUT)

    cfg = DawnBoot::Configuration.finddefault

    email = ENV['EMAIL']
    if email.blank?
      puts "Please set EMAIL=youremail@example.com"
      exit 5
    end
    cfg.admin_email = email

    onboard_url = ENV['ONBOARD']
    cfg.onboard!(onboard_url)

  end
end


