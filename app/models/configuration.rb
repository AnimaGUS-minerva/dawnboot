class Configuration < ApplicationRecord

  def self.default
    self.where(:active => true).order("configurations.lastused_at DESC").first
  end

end
