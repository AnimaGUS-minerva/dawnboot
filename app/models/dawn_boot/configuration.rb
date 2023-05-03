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
  end
end
