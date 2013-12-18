require "spec_helper"

describe Permitter::Permission do
  before do
    @permission = Object.new
    @permission.extend(Permitter::Permission)
  end


  describe 'allow_action' do

    it "allows access to only what is defined" do
      expect(@permission.allowed_action?(:controller, :action)).to be false
      @permission.allow_action(:controller, :action)
      expect(@permission.allowed_action?(:controller, :action)).to be true
      expect(@permission.allowed_action?(:foo, :bar)).to be false
    end

    it "allows access to everything when using allow_all" do
      expect(@permission.allowed_action?(:foo, :bar)).to be false
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
      expect(@permission.allowed_action?(:thud, :baz)).to be false
      expect(@permission.allowed_action?(:foo, :grunt)).to be false
    end

    it "allows strings instead of symbols in permission check" do
      @permission.allow_action(:controller, :action)
      expect(@permission.allowed_action?('controller', 'action')).to be true
    end


    # Block Conditions

    it "executes block passing object only when instance is used" do
      @permission.allow_action :controller, :action do |resource|
        resource == 'foo'
      end
      expect(@permission.allowed_action?(:controller, :action)).to be false
      expect(@permission.allowed_action?(:controller, :action, 'foo')).to be true
      expect(@permission.allowed_action?(:controller, :action, 'bar')).to be false
    end

  end


  describe 'allow_param' do

    it "allows access to only what is defined" do
      expect(@permission.allowed_param?(:resource, :attribute)).to be false
      @permission.allow_param(:resource, :attribute)
      expect(@permission.allowed_param?(:resource, :attribute)).to be true
      expect(@permission.allowed_param?(:foo, :bar)).to be false
    end

    it "allows access to everything when using allow_all" do
      expect(@permission.allowed_param?(:foo, :bar)).to be false
      @permission.allow_all
      expect(@permission.allowed_param?(:foo, :bar)).to be true
      expect(@permission.allowed_param?(:baz, :qux)).to be true
    end

    it "allows access to multiple actions and subjects" do
      @permission.allow_param([:foo, :bar], [:baz, :qux])
      expect(@permission.allowed_param?(:foo, :baz)).to be true
      expect(@permission.allowed_param?(:bar, :baz)).to be true
      expect(@permission.allowed_param?(:foo, :qux)).to be true
      expect(@permission.allowed_param?(:bar, :qux)).to be true
      expect(@permission.allowed_param?(:thud, :baz)).to be false
      expect(@permission.allowed_param?(:foo, :grunt)).to be false
    end

  end

end
