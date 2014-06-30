# Upgrading from Roadie 2

## Project

Start by adding `roadie-rails` to your `Gemfile`. Remember to specify version requirements!

You'll need to change your configuration too. The main change is that Roadie now uses its own configuration for URL options:

```ruby
config.roadie.url_options = {host: "myapp.com"}
```

Most other options should be easy to convert:

```ruby
config.roadie.enabled => Removed
# Override `#roadie_options` in the mailers to control enabling (if using Automatic) or do it manually (if using Mailer).

config.roadie.before_inlining => config.roadie.before_transformation
config.roadie.provider => config.roadie.asset_providers
```

## Mailers

Next, find all mailers that you want to inline and include the `Roadie::Rails::Automatic` module:

```ruby
class MyMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  def cool_mail
    mail(options)
  end
end
```

You'll also need to remove any uses of the `:css` option to `mail` and `default_options`. Include CSS files by using `stylesheet_link_tag` instead.

**Before:**

```ruby
class MyMailer < ActionMailer::Base
  defaults css: :email

  def cool
    mail(css: [:email, :cool])
  end
end
```


**After:**

```erb
<head>
  <%= stylesheet_link_tag :email, :cool %>
</head>
```

## Views

Search through your templates after uses of `data-immutable` and change them to `data-roadie-ignore`.

## Tests

If your tests relied on the styles being applied, they will fail unless you deliver the email. `Roadie::Rails::Automatic` does not inline stylesheets when you don't deliver the email. Either change how your tests work, or call `deliver` on the generated emails where you need it. If the problem is major, switch from `Roadie::Rails::Automatic` to `Roadie::Rails::Mailer` and follow the instructions in the documentation.

## Custom asset providers

The API has changed a bit. Read the new examples in the README and you should be able to convert without any great effort.
