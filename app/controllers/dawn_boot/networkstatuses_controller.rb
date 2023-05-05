class DawnBoot::NetworkstatusesController < ApplicationController

  def index
    @ns = DawnBoot::Networkstatus.most_recent
    unless @ns
      head 404, :text => "no data"
      return
    end
  end

end
