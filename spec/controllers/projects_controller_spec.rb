require "spec_helper"

describe ProjectsController do
  describe "GET #index" do
    let(:project1) { create(:project) }
    let(:project2) { create(:project) }

    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all of the projects into @projects" do
      project1
      project2
      get :index

      expect(assigns(:projects)).to match_array([project1, project2])
    end
  end
end
