module DawnBoot
  class Configuration < ApplicationRecord
    has_many :system_variables

    def self.default
      self.where(:active => true).order("dawn_boot_configurations.lastused_at DESC").first
    end

    def self.create_first
      create(:active => true,
             :name   => "initial",
             :lastused_at => DateTime::now).save!
    end

    def self.finddefault
      default || create_first
    end

    def admin_email=(x)
      system_variables.setvalue(:admin_email, x)
    end
    def admin_email
      lookup(:admin_email)
    end

    def lookup(x)
      system_variables.lookup(x)
    end

    def onboard!(url = lookup(:onboard_url))

      params = Hash.new
      params[:email] = admin_email

      request = Net::HTTP::Post.new(target_uri)
      request.body         = params.to_json
      request.content_type = "text/json"
      request.add_field("Accept", "text/json")

    end

  end
end
