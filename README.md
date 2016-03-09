# roadie-rails

[![Build history and status](https://secure.travis-ci.org/Mange/roadie-rails.png)](http://travis-ci.org/#!/Mange/roadie-rails)
[![Code Climate](https://codeclimate.com/github/Mange/roadie-rails.png)](https://codeclimate.com/github/Mange/roadie-rails)
[![Code coverage status](https://codecov.io/github/Mange/roadie-rails/coverage.svg?branch=master)](https://codecov.io/github/Mange/roadie-rails?branch=master)
[![Gem Version](https://badge.fury.io/rb/roadie-rails.png)](http://badge.fury.io/rb/roadie-rails)
[![Dependency Status](https://gemnasium.com/Mange/roadie-rails.png)](https://gemnasium.com/Mange/roadie-rails)

> Making HTML emails comfortable for the Rails rockstars.

This gem hooks up your Rails application with Roadie to help you generate HTML emails.

## Installation ##

[Add this gem to your Gemfile as recommended by Rubygems][gem] and run `bundle install`.

```ruby
gem 'roadie-rails', '~> 1.0'
```

## Usage ##

`roadie-rails` have two primary means of usage. The first on is the "Automatic usage", which does almost everything automatically. It's the easiest way to hit the ground running in order to see if `roadie` would be a good fit for your application.

As soon as you require some more "advanced" features (congratulations!), you should migrate to the "Manual usage" which entails that you do some things by yourself.

### Automatic usage ###

Include the `Roadie::Rails::Automatic` module inside your mailer. Roadie will do its magic when you try to deliver the message:

```ruby
class NewsletterMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  def user_newsletter(user)
    mail to: user.email, subject: subject_for_user(user)
  end

  private
  def subject_for_user(user)
    I18n.translate 'emails.user_newsletter.subject', name: user.name
  end
end

# email has the original body; Roadie has not been invoked yet
email = NewsletterMailer.user_newsletter(User.first)

# This triggers Roadie inlining and will deliver the email with inlined styles
email.deliver
```

By overriding the `#roadie_options` method in the mailer you can disable inlining in certain cases:

```ruby
class NewsletterMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  private
  def roadie_options
    super unless Rails.env.test?
  end
end
```

Another way:

```ruby
describe YourMailer do
  describe "email contents" do
    before do
      # Disable inlining
      YourMailer.any_instance.stub(:roadie_options).and_return(nil)
    end
    # ...
  end

  describe "inlined email contents" do
    # ...
  end
end
```

If you need the extra flexibility, look at the "Manual usage" below.

### Manual usage ###

Include the `Roadie::Rails::Mailer` module inside your `ActionMailer` and call `roadie_mail` with the same options that you would pass to `mail`.

```ruby
class NewsletterMailer < ActionMailer::Base
  include Roadie::Rails::Mailer

  def user_newsletter(user)
    roadie_mail to: user.email, subject: subject_for_user(user)
  end

  private
  def subject_for_user(user)
    I18n.translate 'emails.user_newsletter.subject', name: user.name
  end
end
```

This will inline the stylesheets right away, which sadly decreases performance for your tests where you might only want to inline in one of them. The upside is that you can selectively inline yourself.

```ruby
class NewsletterMailer < ActionMailer::Base
  include Roadie::Rails::Mailer

  def subscriber_newsletter(subscriber, options = {})
    use_roadie = options.fetch :use_roadie, true
    mail_factory(use_roadie, normal_mail_options)
  end

  private
  def mail_factory(use_roadie, options)
    if use_roadie
      roadie_mail options
    else
      mail options
    end
  end
end

# tests
describe NewsletterMailer do
  it "is emailed to the subscriber's email" do
    email = NewsletterMailer.subscriber_newsletter(subscriber, use_roadie: false)
    email.to.should == subscriber.email
  end

  it "inlines the emails by default" do
    email = NewsletterMailer.subscriber_newsletter(subscriber)
    email.should be_good_and_cool_and_all_that_jazz
  end
end
```

Or, perhaps by doing this:

```ruby
describe YourMailer do
  describe "email contents" do
    before do
      # Redirect all roadie mail calls to the normal mail method
      YourMailer.any_instance.stub(:roadie_mail) { |*args, &block| YourMailer.mail(*args, &block) }
    end
    # ...
  end

  describe "inlined email contents" do
    # ...
  end
end
```

### Configuration ###

Roadie can be configured in three places, depending on how specific you want to be:

1. `Rails.application.config.roadie` (global, static).
2. `YourMailer#roadie_options` (mailer, dynamic).
3. Second argument to the `roadie_mail` (mail, specific and custom).

You can override at any level in the chain, depending on how specific you need to be.

Only the first two methods are available to you if you use the `Automatic` module.

```ruby
# config/environments/production.rb
config.roadie.url_options = {host: "my-app.com", scheme: "https"}

# app/mailer/my_mailer.rb
class MyMailer
  include Roadie::Rails::Mailer

  protected
  def roadie_options
    super.merge(url_options: {host: Product.current.host})
  end
end

# app/mailer/my_other_mailer.rb
class MyOtherMailer
  include Roadie::Rails::Mailer

  def some_mail(user)
    roadie_email {to: "foo@example.com"}, roadie_options_for(user)
  end

  private
  def roadie_options_for(user)
    roadie_options.combine({
      asset_providers: [MyCustomProvider.new(user)],
      url_options: {host: user.subdomain_with_host},
    })
  end
end
```

If you `#merge` you will replace the older value outright:

```ruby
def roadie_options
  original = super
  original.url_options # => {protocol: "https", host: "foo.com"}
  new = original.merge(url_options: {host: "bar.com"})
  new.url_options # => {host: "bar.com"}
  new
end
```

If you want to combine two values, use `#combine`. `#combine` is closer to `Hash#deep_merge`:

```ruby
def roadie_options
  original = super
  original.url_options # => {protocol: "https", host: "foo.com"}
  new = original.combine(url_options: {host: "bar.com"})
  new.url_options # => {protocol: "https", host: "bar.com"}
  new
end
```

`#combine` is smarter than `Hash#deep_merge`, though. It can combine callback `proc`s (so both get called) and `Roadie::ProviderList`s as well.

If you want to see the available configuration options, see the [Roadie gem][roadie].

### Templates ###

Use normal `stylesheet_link_tag` and `foo_path` methods when generating your email and Roadie will look for the precompiled files on your filesystem, or by asking the asset pipeline to compile the files for you if it cannot be found.

### Previewing ###

You can create a controller that gets the email and then renders the body from it.

```ruby
class Admin::EmailsController < AdminController
  def user_newsletter
    render_email NewsletterMailer.user_newsletter(current_user)
  end

  def subscriber_newsletter
    render_email NewsletterMailer.subscriber_newsletter(Subscriber.first || Subscriber.new)
  end

  private
  def render_email(email)
    respond_to do |format|
      format.html { render html: email.html_part.decoded.html_safe }
      format.text { render text: email.text_part.decoded }
    end
  end
end
```

## Known issues ##

Roadie will not be able to find your stylesheets if you have an `asset_host` configured and will ignore those lines when inlining.

A workaround for this is to not use `asset_host` in your mailers:

```ruby
config.action_controller.asset_host = # ...
config.action_mailer.asset_host = nil

# or

class MyMailer < ActionMailer::Base
  self.asset_host = nil
end
```

## Build status ##

Tested with [Travis CI](http://travis-ci.org) using [almost all combinations of](http://travis-ci.org/#!/Mange/roadie-rails):

* Ruby:
  * MRI 1.9.3
  * MRI 2.0
  * MRI 2.1
  * MRI 2.2
  * MRI 2.3.0
  * JRuby (latest)
  * Rubinius (failures on Rubinius will not fail the build due to a long history of instability in `rbx`)
* Rails
  * 3.0
  * 3.1
  * 3.2
  * 4.0
  * 4.1
  * 4.2
  * 5.0 (but only on Ruby 2.2+)

Let me know if you want any other combination supported officially.

### Versioning ###

This project follows [Semantic Versioning][semver].

## Documentation ##

* [Online documentation for gem](https://www.omniref.com/ruby/gems/roadie-rails)
* [Online documentation for master](https://www.omniref.com/github/Mange/roadie-rails)
* [Changelog](https://github.com/Mange/roadie-rails/blob/master/Changelog.md)

## Running specs ##

The default `rake` task will take care of the setup for you.

```bash
rake
```

After running `rake` for the first time and you want to keep running tests without having to install all dependencies, you may run `guard`, `rspec` or `rake spec` depending on what you prefer.

## License ##

(The MIT License)

Copyright © 2013-2016 [Magnus Bergmark](https://github.com/Mange) <magnus.bergmark@gmail.com>, et. al.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


[roadie]: http://rubygems.org/gems/roadie
[semver]: http://semver.org/
[gem]: http://rubygems.org/gems/roadie-rails
