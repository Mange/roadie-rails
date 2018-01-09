module Roadie
  module Rails
  end
end

require "active_support/concern"

require "roadie"

require "roadie/rails/version"
require "roadie/rails/options"

require "roadie/rails/document_builder"
require "roadie/rails/mail_inliner"

require "roadie/rails/asset_pipeline_provider"
require "roadie/rails/css_localizer"

require "roadie/rails/mailer"

require "roadie/rails/automatic"
require "roadie/rails/inline_on_delivery"

require "roadie/rails/railtie"
