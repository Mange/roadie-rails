# How to add another Rails app

You need to follow certain steps in order to construct a proper integration with a new version of Rails. First, a quick summary:

1. Install the correct version of the `rails` gem
2. Using that version of `rails`, generate a new app
3. Strip out things we don't need from the app
4. Copy the mailers and templates to the app
5. Apply Roadie options and add Roadie to the Gemfile
6. Add it to `integration_spec.rb`

## Installing Rails

```bash
gem install rails -v x.y.z
```

## Generate Rails app

```bash
rails _x.y.z._ new rails_x_y --skip-javascript --skip-keeps --skip-active-record --skip-test-unit
```

## Clean up the app

```bash
cd rails_x_y
```

The next step is of course specific to each Rails version. One of the easiest methods is to just start by deleting directories you know you have no use for, like `tmp`, `log` and `README.md`.

```bash
rm -rf README.* tmp log db app/controllers app/helpers app/views/layouts public doc
```

You should also go through the initializers under `config` and remove the ones that don't apply; only keep the `development` environment. You should also strip away documentation comments and similar from all the files under `config`. Make them compact and only keep what is needed.

After doing this, run `git add .` and inspect the list of added files. If there's any file there you didn't intend to add, just remove it with `git rm -f`.

## Copy mailer and templates

```bash
cd ..
rm -rf rails_x_y/app/assets rails_x_y/app/views
ln -s ../../shared/pipeline/app/assets rails_x_y/app/assets
ln -s ../../shared/all/app/mailers rails_x_y/app/mailers
ln -s ../../shared/all/app/views rails_x_y/app/views
```

## Apply options and add gem

Open up `config/application.rb` and add the following options:

```ruby
config.roadie.url_options = {host: 'example.app.org'}
```

Then open up the `Gemfile` and add:

```ruby
gem 'roadie-rails', :path => '../../..'
```

## Add to integration_spec.rb

Add the information needed in `spec/integration_spec.rb` and run `setup.sh` before finally running the tests themselves. When everything's good, `git add` everything and commit.
