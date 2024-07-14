# frozen_string_literal: true

require "test_helper"

class FuncmlcliTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Funcmlcli.const_defined?(:VERSION)
      Funcml.const_defined?(:VERSION)
    end
  end
end
