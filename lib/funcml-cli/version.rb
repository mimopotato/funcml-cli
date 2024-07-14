# frozen_string_literal: true

module Funcmlcli
  VERSION = "0.1.0"

  class Version
    def self.show
      return <<~EOF
        funcml-cli version: #{Funcmlcli::VERSION}
        funcml-core version: #{Funcml::VERSION}
      EOF
    end
  end
end
