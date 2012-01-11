require 'spec_helper'

describe "admin_topics/show" do
  before(:each) do
    @topic = assign(:topic, stub_model(Admin::Topic))
  end

  it "renders attributes in <p>" do
    render
  end
end
