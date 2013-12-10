require "spec_helper"

describe Permission do
  let(:admin) { build(:admin) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:project1) { build(:project, user: user1) }
  let(:project2) { build(:project, user: user2) }


  describe "as admin" do
    subject { Permission.new(admin) }

    it "allows anything" do
      should allow_action(:anything, :here)
      should allow_param(:anything, :here)
    end
  end


  describe "for user" do
    subject { Permission.new(user1) }

    it "projects" do
      should allow_action(:projects, :index)
      should allow_action(:projects, :new)
      should allow_action(:projects, :create)
      should allow_action(:projects, :show)
      should_not allow_action(:projects, :edit)
      should_not allow_action(:projects, :update)
      should_not allow_action(:projects, :edit, project2)
      should_not allow_action(:projects, :update, project2)
      should allow_action(:projects, :edit, project1)
      should allow_action(:projects, :update, project1)
      should_not allow_action(:projects, :destroy)
      should_not allow_action(:projects, :destroy, project1)
      should_not allow_action(:projects, :destroy, project2)
      should allow_param(:project, :title)
      should_not allow_param(:project, :sticky)
    end

    it 'users' do
      should allow_action(:users, :index)
      should_not allow_action(:users, :show)
      should_not allow_action(:users, :show, user2)
      should allow_action(:users, :show, user1)
    end
  end


  describe "for visitor" do
    subject { Permission.new(nil) }

    it "projects" do
      should allow_action(:projects, :index)
      should_not allow_action(:projects, :new)
      should_not allow_action(:projects, :create)
      should_not allow_action(:projects, :show)
      should_not allow_action(:projects, :edit)
      should_not allow_action(:projects, :update)
      should_not allow_action(:projects, :destroy)
      should_not allow_action(:projects, :show, project1)
      should_not allow_action(:projects, :edit, project1)
      should_not allow_action(:projects, :update, project1)
      should_not allow_action(:projects, :destroy, project1)
      should_not allow_action(:projects, :show, project2)
      should_not allow_action(:projects, :edit, project2)
      should_not allow_action(:projects, :update, project2)
      should_not allow_action(:projects, :destroy, project2)
    end
  end
end
