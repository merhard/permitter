require 'spec_helper'

describe UsersController do
  let(:user)  { create(:user) }
  let(:admin) { create(:admin) }

  describe 'GET #index' do
    before do
      unless example.metadata[:skip_before]
        @controller.stub(:current_user) { user }
        get :index
      end
    end

    it 'responds successfully' do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end

    it 'loads all of the users into @projects if admin', skip_before: true do
      @controller.stub(:current_user) { admin }
      get :index
      expect(assigns(:users)).to eq(User.all)
    end

    it 'loads only current user into @projects if not admin' do
      expect(assigns(:users)).to eq([user])
    end

  end

  describe 'GET #show' do
    before do
      unless example.metadata[:skip_before]
        @controller.stub(:current_user) { user }
        get :show, id: user.id
      end
    end

    context 'responds unsuccessfully if' do
      it 'user not signed in', skip_before: true do
        @controller.stub(:current_user) { nil }
        get :show, id: user.id
        expect(response).to_not be_success
        expect(response.status).to eq(302)
        expect(response).to redirect_to(projects_url)
        expect(flash.alert).to eq 'You are not authorized to access this page.'
      end

      it 'user signed in and not current user', skip_before: true do
        @controller.stub(:current_user) { user }
        get :show, id: admin.id
        expect(response).to_not be_success
        expect(response.status).to eq(302)
        expect(response).to redirect_to(projects_url)
        expect(flash.alert).to eq 'You are not authorized to access this page.'
      end
    end

    it 'responds successfully if user signed in and current user' do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end

    it 'loads the user into @user' do
      expect(assigns(:user)).to eq(user)
    end
  end

end
