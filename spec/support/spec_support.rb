module SpecSupport
  def login(user)
    if example.metadata[:type] == :request
      visit("/test/login?user_id=#{user.id}")
      page.should have_content("ok")
    elsif example.metadata[:type] == :controller
      raise "Please use sign_in instead in controller specs"
    elsif example.metadata[:type] == :view
      @ability = Ability.new(user)
      assign(:current_ability, @ability)
      controller.stub(:current_user, user)
      view.stub(:current_user, user)
    else
      raise "Test type #{example.metadata[:type].inspect} not supported"
    end
  end
  
  def visit_html(html)
    File.open('public/_test.html', 'w') do |f|
      f.write(html)
    end
    visit('/_test.html')
  end
  
  def show_topic(site_key, topic_key, options = {})
    pre_js    = options[:pre_js]
    topic_url = options[:topic_url]
    
    visit_html(%Q^
      <div id="comments"></div>
      <script type="text/javascript" class="juvia">
      #{pre_js}
      (function() {
        var container   = '#comments';
        var site_key    = '#{site_key}';
        var topic_key   = '#{topic_key}';
        var topic_url   = #{topic_url ? "'#{topic_url}'" : "location.href"};
        var topic_title = document.title || topic_url;
        
        var s       = document.createElement('script');
        s.async     = true;
        s.type      = 'text/javascript';
        s.className = 'juvia';
        s.src = '/api/show_topic.js' +
	        '?container=' + encodeURIComponent(container) +
	        '&site_key=' + encodeURIComponent(site_key) +
	        '&topic_key=' + encodeURIComponent(topic_key) +
	        '&topic_url=' + encodeURIComponent(topic_url) +
          '&topic_title=' + encodeURIComponent(topic_title);
        (document.getElementsByTagName('head')[0] ||
         document.getElementsByTagName('body')[0]).appendChild(s);
      })();
      </script>
    ^)
  end

  def eventually(max_wait = 5, sleep_time = 0.01)
    deadline = Time.now + max_wait
    while Time.now < deadline
      result = yield
      if result
        return result
      else
        sleep(sleep_time)
      end
    end
    fail "Something that should eventually happen never happened"
  end
end
