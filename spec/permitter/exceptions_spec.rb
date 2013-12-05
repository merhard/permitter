require "spec_helper"

describe Permitter::Unauthorized do
  describe "with action and subject" do
    before(:each) do
      @exception = Permitter::Unauthorized.new(nil, :some_action, :some_subject)
    end

    it "has action and subject accessors" do
      expect(@exception.action).to eq :some_action
      expect(@exception.subject).to eq :some_subject
    end

    it "has a changable default message" do
      expect(@exception.message).to eq "You are not authorized to access this page."
      @exception.default_message = "Unauthorized!"
      expect(@exception.message).to eq "Unauthorized!"
    end
  end

  describe "with only a message" do
    before(:each) do
      @exception = Permitter::Unauthorized.new("Access denied!")
    end

    it "has nil action and subject" do
      expect(@exception.action).to be nil
      expect(@exception.subject).to be nil
    end

    it "has passed message" do
      expect(@exception.message).to eq "Access denied!"
    end
  end

end
