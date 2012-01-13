# About Juvia

![Logo](https://github.com/FooBarWidget/juvia/raw/master/app/assets/images/logo-128.png)

Juvia is an open source commenting system. It allows you to outsource your commenting needs to an external system so that you don't have to build your own commenting system for each website or each web app. Embedding a Juvia commenting page only involves pasting a JavaScript snippet into your web page.

Juvia is similar to [Disqus](http://www.disqus.com/) and [IntenseDebate](http://intensedebate.com/). However both of them seem to be designed in the early 2000s before the rise of AJAX: trying to integrate either of them in an AJAX web application results in many wasted afternoons and a screen full of inexplicable JavaScript errors. Juvia offers full support for AJAX web pages and any JavaScript is written in such a way that it avoids conflicts with the page's existing JavaScripts.

## Installation

1. Clone this repository into a desired directory.
2. Configure your database details by editing config/database.yml. An example is provided in config/database.yml.example. Only edit the information under the 'production' section.
3. Configure other things by editing config/application.yml. An example is provided in config/application.yml.example. Only edit the information under the 'production' section.
4. Run `bundle install --deployment --without=development`
5. Run `bundle exec rake db:schema:load RAILS_ENV=production`
6. Deploy this application to Phusion Passenger or whatever application server you prefer.

You can now access Juvia through the address that you configured. It will ask you to create an initial administrator account and to register a site.

## Upgrade

1. Run `git fetch && git reset --hard origin/master`
2. Run `bundle install --deployment --without=development`
3. Run `bundle exec rake db:migrate RAILS_ENV=production`
4. Run `touch tmp/restart.txt` (if you're using Phusion Passenger) or restart your application server.
