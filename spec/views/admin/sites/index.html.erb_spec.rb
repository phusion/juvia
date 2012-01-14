require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe "admin/sites/index.html.erb" do
  before(:each) do
  	login(kotori)
    assign(:sites, [
      FactoryGirl.create(:site1, :user => kotori),
      FactoryGirl.create(:site2, :user => kotori)
    ])
  end

  it "renders a list of sites" do
  	render
  end
end
