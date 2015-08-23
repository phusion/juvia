require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Admin::TopicsController, type: :controller do
  let(:valid_attributes) { FactoryGirl.attributes_for(:topic) }

  before do
    @site = FactoryGirl.create(:site1, :user => kotori)
    @topic = FactoryGirl.create(:topic, site: @site)
  end

  describe "GET index" do
    def visit_normally
      get :index
    end

    include_examples "requires authentication"
  end

  describe "GET show" do
    def visit_normally
      get :show, :id => @topic.id
    end

    include_examples "requires authentication"
  end

  describe "GET edit" do
    def visit_normally
      get :edit, :id => @topic.id
    end

    include_examples "requires authentication"
  end

  describe "POST create" do
    def visit_normally
      post :create, :topic => valid_attributes
    end

    include_examples "requires authentication"
  end

  describe "PUT update" do
    def visit_normally
      put :update, :id => @topic.id, :topic => valid_attributes
    end

    include_examples "requires authentication"
  end

  describe "DELETE destroy" do
    def visit_normally
      delete :destroy, :id => @topic.id
    end

    include_examples "requires authentication"
  end
end

describe Admin::TopicsController, type: :controller do
  render_views

  before do
    sign_in(admin)
    @site = FactoryGirl.create(:site1, :user => kotori)
    @topic = FactoryGirl.create(:topic, site: @site)
  end

  let(:valid_attributes) { FactoryGirl.attributes_for(:topic) }

  describe "GET show" do
    def visit_normally
      get :show, :id => @topic.id
    end

    it "assigns the requested topic as @topic" do
      visit_normally
      expect(assigns(:topic)).to eq(@topic)
    end
  end

  describe "GET new" do
    it "raises error" do
      expect { get :new}.to raise_error
    end
  end

  describe "GET edit" do
    it "raises error" do
      expect { get :edit}.to raise_error
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested topic" do
      expect {
        delete :destroy, :id => @topic.id
      }.to change(Topic, :count).by(-1)
    end

    it "redirects to the site path" do
      delete :destroy, :id => @topic.id
      expect(response).to redirect_to(admin_site_path(@topic.site))
    end
  end

end
