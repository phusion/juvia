require 'spec_helper'

describe "Admin::Topics" do
  describe "GET /admin_topics" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get admin_topics_path
      response.status.should be(200)
    end
  end
end
