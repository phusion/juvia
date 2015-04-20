require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Comment do
  let(:site) { hatsuneshima }
  let(:topic) { FactoryGirl.create(:topic, :site => site) }

  it "nullifies blank fields" do
    comment = FactoryGirl.create(:comment, :topic => topic, :author_name => "Morishima")
    comment.author_name = ""
    comment.save!
    expect(comment.author_name).to be_nil
  end

  it "strips leading and trailing spaces from the email address" do
    comment = FactoryGirl.create(:comment, :topic => topic)
    comment.author_email = " foo@bar.com "
    expect(comment.author_email).to eq("foo@bar.com")
  end
end