# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
if ENV.fetch('LOCAL_DEV', nil)
  $LOAD_PATH.unshift File.expand_path("../../funcml-core/lib", __dir__)
end

require "funcml-core"
require "funcml-cli"

require "test-unit"
