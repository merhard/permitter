require "spec_helper"

describe ProjectsController do
  let(:user)  { create(:user) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:admin) { create(:admin) }
  let(:project)  { create(:project) }
  let(:project1) { create(:project, user: user1) }
  let(:project2) { create(:project, user: user2) }

  describe "GET #index" do
    before { get :index }

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      expect(response).to render_template("index")
    end

    it "loads all of the projects into @projects" do
      expect(assigns(:projects)).to match_array([project1, project2])
    end
  end


  describe "GET #show" do
    before do
      unless example.metadata[:skip_before]
        controller.current_user = user
        get :show, id: project.id
      end
    end

    it "responds unsuccessfully with an HTTP 302 status code if user not signed in", skip_before: true do
      get :show, id: project.id
      expect(response).to_not be_success
      expect(response.status).to eq(302)
    end

    it "responds successfully with an HTTP 200 status code if user signed in" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the show template" do
      expect(response).to render_template("show")
    end

    it "loads the project into @project" do
      expect(assigns(:project)).to eq(project)
    end
  end


end
