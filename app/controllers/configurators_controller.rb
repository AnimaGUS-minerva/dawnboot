class ConfiguratorsController < ApplicationController

  def index
    @config = DawnBoot::Configuration.default
  end

end
