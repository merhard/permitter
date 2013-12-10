require "spec_helper"

describe ProjectsController do
  before { @controller.stub(:current_user) { nil } }
  let(:user)  { build(:user) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:admin) { build(:admin) }
  let(:project)  { create(:project) }
  let(:project1) { create(:project, user: user1) }
  let(:project2) { create(:project, user: user2) }

  describe "GET #index" do
    before { get :index }

    it "responds successfully" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      expect(response).to render_template("index")
    end

    it "loads all of the projects into @projects" do
      expect(assigns(:projects)).to eq(Project.all)
    end
  end


  describe "GET #show" do
    before do
      unless example.metadata[:skip_before]
        @controller.stub(:current_user) { user }
        get :show, id: project.id
      end
    end

    it "responds unsuccessfully if user not signed in", skip_before: true do
      get :show, id: project.id
      expect(response).to_not be_success
      expect(response.status).to eq(302)
      expect(response).to redirect_to(projects_url)
      expect(flash.alert).to eq("You are not authorized to access this page.")
    end

    it "responds successfully if user signed in" do
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
        @controller.stub(:current_user) { user }
        get :new
      end
    end

    it "responds unsuccessfully if user not signed in", skip_before: true do
      get :new
      expect(response).to_not be_success
      expect(response.status).to eq(302)
      expect(response).to redirect_to(projects_url)
      expect(flash.alert).to eq("You are not authorized to access this page.")
    end

    it "responds successfully if user signed in" do
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
    let(:title)  { 'Title' }
    let(:sticky) { true }
    before do
      unless example.metadata[:skip_before]
        @controller.stub(:current_user) { user }
        post :create, project: {title: title, sticky: sticky}
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

    it "does not assign sticky variable" do
      expect(assigns(:project).title).to eq(title)
      expect(assigns(:project).sticky).to be_nil
    end
  end


  describe "GET #edit" do
    before do
      unless example.metadata[:skip_before]
        @controller.stub(:current_user) { user1 }
        get :edit, id: project1.id
      end
    end

    it "responds unsuccessfully if user not signed in", skip_before: true do
      get :edit, id: project.id
      expect(response).to_not be_success
      expect(response.status).to eq(302)
      expect(response).to redirect_to(projects_url)
      expect(flash.alert).to eq("You are not authorized to access this page.")
    end

    it "responds unsuccessfully if user not associated with project", skip_before: true do
      @controller.stub(:current_user) { user1 }
      get :edit, id: project2.id
      expect(response).to_not be_success
      expect(response.status).to eq(302)
      expect(response).to redirect_to(projects_url)
      expect(flash.alert).to eq("You are not authorized to access this page.")
    end

    it "responds successfully if user associated with project" do
      expect(response.status).to eq(200)
    end

    it "renders the edit template" do
      expect(response).to render_template("edit")
    end

    it "loads the project into @project" do
      expect(assigns(:project)).to eq(project1)
    end
  end


  describe "PATCH #update" do
    let(:title) { 'Updated Title' }
    let(:sticky) { true }

    before do
      unless example.metadata[:skip_before]
        @controller.stub(:current_user) { user1 }
        @original_title = project1.title
        @original_sticky = project1.sticky
        patch :update, id: project1.id, project: {title: title, sticky: sticky}
      end
    end

    it "responds unsuccessfully if user not signed in", skip_before: true do
      patch :update, id: project.id
      expect(response).to_not be_success
      expect(response.status).to eq(302)
      expect(response).to redirect_to(projects_url)
      expect(flash.alert).to eq("You are not authorized to access this page.")
    end

    it "responds unsuccessfully if user not associated with project", skip_before: true do
      @controller.stub(:current_user) { user1 }
      patch :update, id: project2.id
      expect(response).to_not be_success
      expect(response.status).to eq(302)
      expect(response).to redirect_to(projects_url)
      expect(flash.alert).to eq("You are not authorized to access this page.")
    end

    it "responds successfully if user associated with project" do
      expect(response.status).to eq(302)
      expect(response).to redirect_to(project_url(assigns(:project)))
      expect(flash.notice).to eq("Project was successfully updated.")
    end

    it "updates a project" do
      expect(assigns(:project).title).to eq(title)
      expect(assigns(:project).title).to_not eq(@original_title)
    end

    it "does not update sticky" do
      expect(assigns(:project).sticky).to eq(@original_sticky)
      expect(assigns(:project).sticky).to_not eq(sticky)
    end
  end


  describe "DELETE #destroy" do

    it "responds unsuccessfully if user not signed in" do
      delete :destroy, id: project.id
      expect(flash.alert).to eq("You are not authorized to access this page.")
    end

    it "responds unsuccessfully if user not an admin" do
      @controller.stub(:current_user) { user1 }
      delete :destroy, id: project1.id
      expect(flash.alert).to eq("You are not authorized to access this page.")
    end

    it "responds successfully if user an admin" do
      @controller.stub(:current_user) { admin }
      delete :destroy, id: project.id
      expect(flash.alert).to be nil
    end

    it "destroys a project" do
      expect(Project.all).to include(project)

      @controller.stub(:current_user) { admin }
      delete :destroy, id: project.id
      expect(Project.all).to_not include(project)
    end
  end


end
