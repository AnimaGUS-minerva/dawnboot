require 'rails_helper'

RSpec.describe "Configurators", type: :request do

  # get named route helpers
  include Rails.application.routes.url_helpers

  describe "GET /index" do

    it "should return answer with initial page" do
      get configurators_path
      expect(response).to have_http_status(200)
    end

  end
end
