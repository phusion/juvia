require 'spec_helper'

describe "admin_topics/index" do
  before(:each) do
    assign(:admin_topics, [
      stub_model(Admin::Topic),
      stub_model(Admin::Topic)
    ])
  end

  it "renders a list of admin_topics" do
    render
  end
end
