# Precondition: not logged in
shared_examples "requires authentication" do
  it "requires authentication" do
    visit_normally
    response.should redirect_to(new_user_session_url)
  end
end

# Precondition: not logged in
shared_examples "doesn't require authentication" do
  it "doesn't require authentication" do
    visit_normally
    response.should_not redirect_to(new_user_session_url)
  end
end

# Precondition: not logged in
shared_examples "requires administrator rights" do
  it "requires administrator rights" do
    sign_in(@user || kotori)
    visit_normally
    response.should render_template("shared/admin_required")
  end
end

