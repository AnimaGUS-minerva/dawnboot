require 'rails_helper'

RSpec.describe DawnBoot::Configuration, type: :model do

  it "should have a default configuration entry from fixtures" do
    expect(DawnBoot::Configuration.default).to_not be_nil
  end

  it "should create a default configuration entry when empty" do
    DawnBoot::Configuration.delete_all
    expect(DawnBoot::Configuration.finddefault).to_not be_nil
  end

end
