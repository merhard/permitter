require "spec_helper"

describe Permitter::Permission do
  before(:each) do
    @permission = Object.new
    @permission.extend(Permitter::Permission)
  end


  # Basic Action & Subject

  it "allows access to only what is defined" do
    expect(@permission.allowed_action?(:controller, :action)).to_not be true
    @permission.allow_action(:controller, :action)
    expect(@permission.allowed_action?(:controller, :action)).to be true
    expect(@permission.allowed_action?(:foo, :bar)).to_not be true
  end

  it "allows access to everything when using allow_all" do
    expect(@permission.allowed_action?(:foo, :bar)).to_not be true
    @permission.allow_all
    expect(@permission.allowed_action?(:foo, :bar)).to be true
    expect(@permission.allowed_action?(:baz, :qux)).to be true
  end

  it "allows access to multiple actions and subjects" do
    @permission.allow_action([:foo, :bar], [:baz, :qux])
    expect(@permission.allowed_action?(:foo, :baz)).to be true
    expect(@permission.allowed_action?(:bar, :baz)).to be true
    expect(@permission.allowed_action?(:foo, :qux)).to be true
    expect(@permission.allowed_action?(:bar, :qux)).to be true
    expect(@permission.allowed_action?(:thud, :baz)).to_not be true
    expect(@permission.allowed_action?(:foo, :grunt)).to_not be true
  end

  it "allows strings instead of symbols in ability check" do
    @permission.allow_action(:controller, :action)
    expect(@permission.allowed_action?('controller', 'action')).to be true
  end


  # Block Conditions

  it "executes block passing object only when instance is used" do
    @permission.allow_action :controller, :action do |resource|
      resource == 'foo'
    end
    expect(@permission.allowed_action?(:controller, :action)).to_not be true
    expect(@permission.allowed_action?(:controller, :action, 'foo')).to be true
    expect(@permission.allowed_action?(:controller, :action, 'bar')).to_not be true
  end

end
