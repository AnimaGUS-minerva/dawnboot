class Configuration < ApplicationRecord
  has_many :system_variables

  def self.default
    self.where(:active => true).order("configurations.lastused_at DESC").first
  end

end
