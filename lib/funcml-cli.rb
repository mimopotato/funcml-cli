# frozen_string_literal: true

require_relative "funcml-cli/patch/hash"

require_relative "funcml-cli/version"
require_relative "funcml-cli/render_all"
require_relative "funcml-cli/render"

module Funcmlcli
  class Error < StandardError; end
end
