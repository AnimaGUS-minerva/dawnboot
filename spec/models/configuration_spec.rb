require 'rails_helper'

RSpec.describe Configuration, type: :model do

  it "should have a default configuration entry" do
    expect(Configuration.default).to_not be_nil
  end

end
