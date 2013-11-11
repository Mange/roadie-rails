RSpec::Matchers.define :have_selector do |selector|
  match { |dom| dom.at_css selector }
end
