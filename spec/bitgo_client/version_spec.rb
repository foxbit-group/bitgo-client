# frozen_string_literal: true

RSpec.describe BitgoClient do
  it "has a version number" do
    expect(BitgoClient::VERSION).not_to be nil
  end
end
