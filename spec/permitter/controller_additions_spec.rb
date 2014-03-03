require 'spec_helper'

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
    @controller.stub(:current_permissions) do
      StubbedPermission.new(@current_user)
    end

    @controller_class.send(:include, Permitter::ControllerAdditions)
  end

  describe 'allowed_action?' do
    it 'goes through the current permissions' do
      expect(@controller.allowed_action?(:foo, :bar)).to be true
      expect(@controller.allowed_action?(:foo, :baz)).to be false
    end
  end

  describe 'authorize_user!' do
    it 'should raise Unauthorized when user not authoried' do
      authorization = lambda do |action|
        @params.merge!(controller: 'foo', action: action)
        @controller.instance_eval { authorize_user! }
      end
      error = Permitter::Unauthorized

      expect { authorization.call('bar') }.to_not raise_error
      expect { authorization.call('baz') }.to raise_error error
    end
  end

end
