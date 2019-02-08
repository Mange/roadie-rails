# frozen_string_literal: true

RSpec::Matchers.define :have_no_styling do
  chain(:at_selector) { |selector| @selector = selector }

  match do |document|
    @selector ||= "body > *:first"
    styles_at_selector(document).empty?
  end

  description do
    "have no styles at selector #{@selector.inspect}"
  end

  failure_message do |document|
    "expected no styles at #{@selector.inspect} but had:\n" \
      "#{styles_at_selector(document)}"
  end

  failure_message_when_negated do
    "expected #{@selector.inspect} to have styles"
  end

  def styles_at_selector(document)
    expect(document).to have_selector(@selector)
    document.at_css(@selector)["style"] || ""
  end
end
