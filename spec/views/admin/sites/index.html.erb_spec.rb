require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe "admin/sites/index.html.erb", type: :view do
  before(:each) do
  	sign_in(kotori)
  end

  it "renders a list of sites" do
    assign(:sites, [
      FactoryGirl.create(:site1, :user => kotori),
      FactoryGirl.create(:site2, :user => kotori)
    ])
  	render
  end
end
