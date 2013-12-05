require "spec_helper"

describe Permitter::ControllerAdditions do
  before(:each) do
    @controller_class = ApplicationController
    @controller = @controller_class.new
    @controller.stub(:current_user) { :current_user }
    ActionController::Base.send(:include, Permitter::ControllerAdditions)
  end

  it "provides an allowed_action? method which goes through the current permissions" do
    # expect(@controller.allowed_action?(:foo, :bar)).to be true
    # expect(@controller.allowed_action?(:foo, :baz)).to be false
  end

  it "authorize_user! should raise Unauthorized when user not authoried" do
    authorization = ->(action) do
      @controller.params = { controller: 'foo', action: action }
      @controller.instance_eval{ authorize_user! }
    end

    # expect(-> {authorization.call('bar')}).to_not raise_error
    # expect(-> {authorization.call('baz')}).to raise_error Permitter::Unauthorized
  end


end
