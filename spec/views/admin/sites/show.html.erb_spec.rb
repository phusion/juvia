require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe "admin/sites/show.html.erb" do
  before(:each) do
    login(kotori)
    @site = assign(:site, FactoryGirl.create(:site1, :user => kotori))
    @topic = FactoryGirl.create(:topic, :site => @site)
  end

  it "shows the site key" do
    render
    rendered.should include(@site.key)
  end

  it "shows a list of topics" do
    render
    rendered.should have_selector('.topics.list')
  end
end
