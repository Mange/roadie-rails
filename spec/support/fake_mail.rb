# frozen_string_literal: true

require "mail"

class FakeMail < Mail::Message
  def delivered?
    @delivered
  end

  def deliver
    @delivered = true
  end

  def deliver!
    @delivered = true
  end
end
