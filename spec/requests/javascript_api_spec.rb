require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

shared_examples "posting new comments with the Javascript API" do
  it "initially has no preview", :js => true do
    show_topic(@site_key, @topic_key)
    expect(page).to have_css('.juvia-preview-empty', :visible => true)
    expect(page).to have_css('.juvia-preview-content', :visible => false)
  end
  
  it "previews the comment while it's being typed", :js => true do
    show_topic(@site_key, @topic_key)
    fill_in 'content', :with => 'hello *world*'
    expect(page).to have_css('.juvia-preview-empty', :visible => false)
    expect(page).to have_css('.juvia-preview-content',
      :text => 'hello world',
      :visible => true)
  end
  
  it "hides the preview box when the comment box is made empty", :js => true do
    show_topic(@site_key, @topic_key)
    fill_in 'content', :with => 'hello *world*'
    expect(page).to have_css('.juvia-preview-content', :visible => true)
    fill_in 'content', :with => ''
    # Manually trigger keyup event, for some reason it is triggered
    # in the browser but not in this test.
    page.execute_script('Juvia.$("textarea").keyup()')
    expect(page).to have_css('.juvia-preview-empty', :visible => true)
    expect(page).to have_css('.juvia-preview-content', :visible => false)
  end
  
  it "disallows posting empty comments", :js => true do
    show_topic(@site_key, @topic_key)
    click_button 'Submit'
    expect(page).to have_css('.juvia-error',
      :text => "You didn't write anything.",
      :visible => true)
  end
  
  it "displays newly posted comments and resets the form", :js => true do
    show_topic(@site_key, @topic_key)
    fill_in 'author_name', :with => 'Kotori'
    fill_in 'author_email', :with => 'kotori@kotori.jp'
    fill_in 'content', :with => 'a *new* comment!'
    click_button 'Submit'
    expect(page).to have_css('.juvia-data', :text => 'a new comment!')
    expect(page).to have_css('.juvia-author', :text => 'Kotori')
  end
  
  it "resets the form after posting", :js => true do
    show_topic(@site_key, @topic_key)
    fill_in 'author_name', :with => 'Kotori'
    fill_in 'author_email', :with => 'kotori@kotori.jp'
    fill_in 'content', :with => 'a *new* comment!'
    click_button 'Submit'
    expect(page).to have_field('author_name', :with => 'Your name (optional)')
    expect(page).to have_field('author_email', :with => 'Your email (optional)')
    expect(page).to have_field('content', :with => '')
  end
  
  it "hides the preview box after posting", :js => true do
    show_topic(@site_key, @topic_key)
    fill_in 'content', :with => 'a *new* comment!'
    expect(page).to have_css('.juvia-preview-content', :visible => true)
    click_button 'Submit'
    expect(page).to have_css('.juvia-preview-empty', :visible => true)
    expect(page).to have_css('.juvia-preview-content', :visible => false)
  end
  
  it "saves all the necessary information about the author and the comment", :js => true do
    show_topic(@site_key, @topic_key)
    fill_in 'author_name', :with => 'Kotori'
    fill_in 'author_email', :with => 'kotori@kotori.jp'
    fill_in 'content', :with => 'a *new* comment!'
    click_button 'Submit'
    
    # Wait until comment is saved.
    expect(page).to have_css('.juvia-data', :text => 'a new comment!')
    
    comment = Comment.last
    expect(comment.moderation_status).to eq(:ok)
    expect(comment.author_name).to eq('Kotori')
    expect(comment.author_email).to eq('kotori@kotori.jp')
    expect(comment.content).to eq('a *new* comment!')
    expect(comment.author_ip).to eq('127.0.0.1')
    expect(comment.author_user_agent).to match(/capybara-webkit/)
    expect(comment.referer).to include("127.0.0.1")
  end
end

shared_examples "showing a topic and commenting with the Javascript API" do
  describe "when working with a nonexistant topic for an existing site" do
    before :each do
      @site_key  = hatsuneshima.key
      @topic_key = 'foo'
    end
    
    it "says that there are no comments", :js => true do
      show_topic('hatsuneshima', 'foo')
      expect(page).to have_css('#comments', :text => /There are no comments yet/)
    end
    
    it "hides the 'there are no comments' text after posting", :js => true do
      show_topic(@site_key, @topic_key)
      fill_in 'content', :with => 'a *new* comment!'
      click_button 'Submit'
      expect(page).to have_no_css('#comments', :text => /There are no comments yet/)
    end
    
    it "creates the topic upon posting and sets its URL to the given topic_url", :js => true do
      show_topic(@site_key, @topic_key, :topic_url => 'http://my-origin.local')
      fill_in 'content', :with => 'a *new* comment!'
      click_button 'Submit'
      
      # Wait until comment is saved.
      expect(page).to have_css('.juvia-data', :text => 'a new comment!')
      
      topic = Topic.find_by_key(@topic_key)
      expect(topic.url).to eq('http://my-origin.local')
    end
    
    include_examples "posting new comments with the Javascript API"
  end
  
  describe "when working with an existing topic for an existing site" do
    before :each do
      @topic ||= FactoryGirl.create(:topic, :site => hatsuneshima)
      FactoryGirl.create(:comment, :content => 'first post', :topic => @topic)
      FactoryGirl.create(:comment, :content => 'second post', :topic => @topic)
      @site_key  = hatsuneshima.key
      @topic_key = @topic.key
    end
    
    it "displays all comments", :js => true do
      show_topic(@site_key, @topic_key)
      expect(page).to have_css('.juvia-data', :text => 'first post')
      expect(page).to have_css('.juvia-data', :text => 'second post')
    end
    
    it "doesn't change the topic's URL even if topic_url is different", :js => true do
      show_topic(@site_key, @topic_key, :topic_url => 'http://my-origin.local')
      fill_in 'content', :with => 'a *new* comment!'
      click_button 'Submit'
      
      # Wait until comment is saved.
      expect(page).to have_css('.juvia-data', :text => 'a new comment!')
      
      topic = Topic.find_by_key(@topic_key)
      expect(topic.url).to eq('http://www.google.com')
    end
    
    include_examples "posting new comments with the Javascript API"
  end
  
  describe "when loading a topic for a nonexistant site" do
    it "displays an error message", :js => true do
      show_topic('foo', 'bar')
      expect(page).to have_css("#comments", :text => /Oops, we don't recognize this site key/)
    end
  end
end

describe "Javascript API", "on browsers with CORS support" do
  specify "the test driver supports Javascript and CORS", :js => true do
    visit_html(%Q^
      <script>
        if (window.XMLHttpRequest) {
          var xhr = new XMLHttpRequest();
          document.writeln('withCredentials' in xhr);
        } else {
          document.writeln(false);
        }
      </script>
    ^)
    expect(page).to have_content('true')
  end
  
  include_examples "showing a topic and commenting with the Javascript API"
end

describe "Javascript API", "on browsers without CORS support" do
  def show_topic(site_key, topic_key, options = {})
    super(site_key, topic_key, options.merge(
      :pre_js => %Q{
        var Juvia = { supportsCors: false };
      })
    )
  end
  
  include_examples "showing a topic and commenting with the Javascript API"
end

describe "Javascript API", "error handling", type: :request do
  describe "show_topic" do
    it "returns an error if a required parameter is blank", :js => true do
      visit_html(%Q^
        <div class="comments"></div>
        <script src="/api/show_topic.js?container=.comments&amp;site_key="></script>
      ^)
      expect(page).to have_css('.comments', :text => /The required parameter site_key wasn't given/)
    end
  end

  describe "add_comment" do
    it "returns an error if a required parameter is blank", focus: true do
      post '/api/add_comment.js', :site_key => ''
      expect(response.body).to include("<h1>API invocation error</h1>\nThe required parameter <code>site_key</code> wasn't given.\n".to_json)
    end
  end
end

