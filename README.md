# About Juvia

![Logo](https://github.com/phusion/juvia/raw/master/app/assets/images/logo-128.png)

Juvia is an open source commenting system. It allows you to outsource your commenting needs to an external system so that you don't have to build your own commenting system for each website or each web app. Embedding a Juvia commenting page only involves pasting a JavaScript snippet into your web page.

Juvia is similar to [Disqus](http://www.disqus.com/) and [IntenseDebate](http://intensedebate.com/). However both of them seem to be designed in the early 2000s before the rise of AJAX: trying to integrate either of them in an AJAX web application results in many wasted afternoons and a screen full of inexplicable JavaScript errors. Juvia offers full support for AJAX web pages and any JavaScript is written in such a way that it avoids conflicts with the page's existing JavaScripts.

Juvia currently also makes no effort to support nested comments. I believe nested comments only make sense for extremely active discussion forums. Instead, Juvia strives for simplicity.

Other notable highlights:

 * Moderation support, either manually or automatically via [Akismet](http://akismet.com/).
 * Multi-user support. With this I don't mean commenters but users who operate the Juvia admin panel. Each user account is isolated and can only see and manage its own sites, topics and comments, except for administrators who can see and manage everything.
 * Email notification of new comments.
 * Wordpress comment import (thanks to JangoSteve).

## Discussion & support

Please join [the Juvia discussion forum](https://groups.google.com/forum/?fromgroups#!forum/juvia).

## Demo

You can see Juvia in action at [the demo site](http://juvia-demo.phusion.nl). Login with `a@a.com` / `123456`. Post comments at [this test comments page](http://juvia-demo.phusion.nl/admin/sites/1/test). The demo site is reset every 24 hours.

<img src="http://brightbox.com/images/misc/logo.png">

The demo site is hosted on a server by [Brightbox](http://www.brightbox.com).

## Installation

1. Clone this repository into a desired directory and `cd` to it.
2. Configure your database details by editing config/database.yml. An example is provided in config/database.yml.example. Only edit the information under the 'production' section.
3. Configure other things by editing config/application.yml. An example is provided in config/application.yml.example. Only edit the information under the 'production' section. You can also set this information in environment variables. See application.yml.example for details.
4. Install the necessary dependencies: `bundle install --without='development test postgres sqlite' --path=help`
5. Install the database schema: `bundle exec rake db:schema:load RAILS_ENV=production`
6. Compile the static assets: `bundle exec rake assets:precompile RAILS_ENV=production RAILS_GROUPS=assets`
7. Deploy this application to Phusion Passenger or whatever application server you prefer.

You can now access Juvia through the address that you configured. It will ask you to create an initial administrator account and to register a site.

## Upgrade

1. `cd` to the source directory and update the code to the latest version: `git fetch && git reset --hard origin/master`
2. Install the necessary dependencies: `bundle install --without='development test' --path=help`
3. Upgrade the database schema: `bundle exec rake db:migrate RAILS_ENV=production`
4. Compile the static assets: `bundle exec rake assets:precompile RAILS_ENV=production RAILS_GROUPS=assets`
5. Run `touch tmp/restart.txt` (if you're using Phusion Passenger) or restart your application server.

## Cryptographic verification

I do not release source tarballs for Juvia. Users are expected to get the source code from Github.

From time to time, I create Git tags for milestones. These milestones are signed with the [Phusion Software Signing key](http://www.phusion.nl/about/gpg). After importing this key you can verify Git tags as follows:

    git tag --verify milestone-2013-03-11

## Rails helper

James Smith has written a Rails helper gem for embedding Juvia comments into Rails web applications. See [juvia_rails](https://github.com/theodi/juvia_rails).

## TODO

Juvia currently suits my need so I may or may not work on these things in the future. But if you want to contribute you are more than welcome to do so!

 * A better logo. I drew the current one in Inkscape in about an hour but I'm sure real artists can do better.
 * Juvia works fine but we need more tests to prevent things from breaking in the future.
 * Document the `list_topics` API call.
 * A Quote/Reply button for each comment.
 * Export support. Not sure whether this is necessary, the user may as well backup the entire database.
 * Email notification for commenters.
 * Moderation teams. Currently each site is owned by exactly one user, and only that user or the administrator can moderate comments. And right now only the site's owner is notified by email of new comments.
 * Better interface for low-resolution screens like mobile phones.
 * Allow commenters to edit their comments. Of course, this requires some way to authenticate the commenter. Maybe Juvia can send an email with a time-limited authentication code (assuming the commenter specified his email in the first place).
