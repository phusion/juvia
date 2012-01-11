require 'spec_helper'

describe "admin_topics/edit" do
  before(:each) do
    @topic = assign(:topic, stub_model(Admin::Topic))
  end

  it "renders the edit topic form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_topics_path(@topic), :method => "post" do
    end
  end
end
