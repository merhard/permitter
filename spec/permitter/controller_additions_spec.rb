require "spec_helper"

class StubbedPermission
  include Permitter::Permission

  def initialize(user)
    allow_action :foo, :bar
  end

end


describe Permitter::ControllerAdditions do
  before(:each) do
    @params = HashWithIndifferentAccess.new
    @current_user = nil

    @controller_class = Class.new
    @controller = @controller_class.new

    @controller.stub(:params) { @params }
    @controller_class.stub(:helper_method) { :helper_method }
    @controller.stub(:current_permissions) { StubbedPermission.new(@current_user) }

    @controller_class.send(:include, Permitter::ControllerAdditions)
  end

  it "provides an allowed_action? method which goes through the current permissions" do
    expect(@controller.allowed_action?(:foo, :bar)).to be true
    expect(@controller.allowed_action?(:foo, :baz)).to be false
  end

  it "authorize_user! should raise Unauthorized when user not authoried" do
    authorization = ->(action) do
      @params.merge!(controller: "foo", action: action)
      @controller.instance_eval{ authorize_user! }
    end

    expect(-> {authorization.call('bar')}).to_not raise_error
    expect(-> {authorization.call('baz')}).to raise_error Permitter::Unauthorized
  end


end
