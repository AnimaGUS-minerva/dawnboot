require 'rails_helper'

RSpec.describe DawnBoot::Configuration, type: :model do

  it "should have a default configuration entry from fixtures" do
    expect(DawnBoot::Configuration.default).to_not be_nil
  end

  it "should create a default configuration entry when empty" do
    DawnBoot::Configuration.delete_all
    expect(DawnBoot::Configuration.finddefault).to_not be_nil
  end

  describe "onboarding" do
    it "should connect to nightclerk and get an activity url" do
      cfg = DawnBoot::Configuration.finddefault
      email = "admin@example.com"
      url   = "http://localhost:3100/appliances"
      act   = '/activities/12345'

      stub_request(:post, "http://localhost:3100/appliances").
        with(headers: {
               'Accept'=>['*/*', 'application/json'],
               'Content-Type'=>'application/json',
               'Host'=>'localhost:3100',
             }).
        to_return(status: 201,
                  headers: {
                    'Location' => act,
                  })

      cfg.admin_email = email
      cfg.onboard!(url)
      expect(cfg.string(:enroll_activity)).to eq(act)
    end
  end

end
