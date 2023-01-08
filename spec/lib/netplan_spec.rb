require 'rails_helper'

RSpec.describe Netplan, type: :model do
  it "should parse a sample file" do
    file="spec/files/netplan01.yml"
    n = Netplan.new
    n.parse_file(file)
    byebug
    expect(n).to_not be_nil
  end

end

