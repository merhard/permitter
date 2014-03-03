require 'spec_helper'
require 'permitter/matchers'

describe Permission do
  context 'as guest' do

    subject { Permission.new(nil) }

    it 'allows new sessions' do
      # Define what a guest is allowed to do
      # should allow_action(:sessions, :new)
      # should allow_action(:sessions, :create)
      # should_not allow_action(:sessions, :destroy)
    end

  end
end
