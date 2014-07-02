RSpec::Matchers.define :have_no_styling do
  chain(:at_selector) { |selector| @selector = selector }

  match { |document|
    @selector ||= 'body > *:first'
    styles_at_selector(document).empty?
  }

  description {
    "have no styles at selector #{@selector.inspect}"
  }

  failure_message { |document|
    "expected no styles at #{@selector.inspect} but had:\n#{styles_at_selector(document)}"
  }

  failure_message_when_negated {
    "expected #{@selector.inspect} to have styles"
  }

  def styles_at_selector(document)
    expect(document).to have_selector(@selector)
    document.at_css(@selector)['style'] || ""
  end
end
