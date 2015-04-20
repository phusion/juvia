require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe "admin/sites/show.html.erb", type: :view do
  before(:each) do
    sign_in(kotori)
    @site = assign(:site, FactoryGirl.create(:site1, :user => kotori))
    @topic = FactoryGirl.create(:topic, :site => @site)
  end

  it "shows the site key" do
    render
    expect(rendered).to include(@site.key)
  end

  it "shows a list of topics" do
    render
    expect(rendered).to have_selector('.topics.list')
  end
end
