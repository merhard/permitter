require "spec_helper"

describe "allow_action" do
  it "delegates to allow_action?" do
    object = Object.new
    expect(object).to receive(:allowed_action?).with(:foo, :bar) { true }
    expect(object).to allow_action(:foo, :bar)
  end
end
