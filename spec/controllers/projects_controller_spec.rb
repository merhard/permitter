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
      expect(response).to redirect_to(projects_url)
      expect(flash.alert).to eq("You are not authorized to access this page.")
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


  describe "GET #new" do
    before do
      unless example.metadata[:skip_before]
        controller.current_user = user
        get :new
      end
    end

    it "responds unsuccessfully with an HTTP 302 status code if user not signed in", skip_before: true do
      get :new
      expect(response).to_not be_success
      expect(response.status).to eq(302)
      expect(response).to redirect_to(projects_url)
      expect(flash.alert).to eq("You are not authorized to access this page.")
    end

    it "responds successfully with an HTTP 200 status code if user signed in" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the new template" do
      expect(response).to render_template("new")
    end

    it "builds a new project into @project" do
      expect(assigns(:project)).to be_a_new(Project)
    end
  end


  describe "POST #create" do
    before do
      unless example.metadata[:skip_before]
        controller.current_user = user
        post :create
      end
    end

    it "responds unsuccessfully if user not signed in", skip_before: true do
      post :create
      expect(response.status).to eq(302)
      expect(response).to redirect_to(projects_url)
      expect(flash.alert).to eq("You are not authorized to access this page.")
    end

    it "responds successfully if user signed in" do
      expect(response.status).to eq(302)
      expect(response).to redirect_to(project_url(assigns(:project)))
      expect(flash.notice).to eq("Project was successfully created.")
    end

    it "creates a new project" do
      expect(assigns(:project)).to eq(Project.last)
    end
  end


  describe "GET #edit" do
    before do
      unless example.metadata[:skip_before]
        controller.current_user = user1
        get :edit, id: project1.id
      end
    end

    it "responds unsuccessfully with an HTTP 302 status code if user not signed in", skip_before: true do
      get :edit, id: project.id
      expect(response).to_not be_success
      expect(response.status).to eq(302)
      expect(response).to redirect_to(projects_url)
      expect(flash.alert).to eq("You are not authorized to access this page.")
    end

    it "responds unsuccessfully with an HTTP 302 status code if user not associated with project", skip_before: true do
      controller.current_user = user1
      get :edit, id: project2.id
      expect(response).to_not be_success
      expect(response.status).to eq(302)
      expect(response).to redirect_to(projects_url)
      expect(flash.alert).to eq("You are not authorized to access this page.")
    end

    it "responds successfully with an HTTP 200 status code if user associated with project" do
      expect(response.status).to eq(200)
    end

    it "renders the edit template" do
      expect(response).to render_template("edit")
    end

    it "loads the project into @project" do
      expect(assigns(:project)).to eq(project1)
    end
  end


end
