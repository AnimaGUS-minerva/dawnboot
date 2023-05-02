require 'rails_helper'

RSpec.describe "DawnBoot::Networkstatuses", type: :request do
  describe "Network status" do
    it "should return current status" do
      get network
    end

    it "should immediately re-test network connectivity" do
    end
  end
end
