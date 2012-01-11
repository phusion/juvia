require 'spec_helper'

describe "admin_topics/new" do
  before(:each) do
    assign(:topic, stub_model(Admin::Topic).as_new_record)
  end

  it "renders new topic form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_topics_path, :method => "post" do
    end
  end
end
