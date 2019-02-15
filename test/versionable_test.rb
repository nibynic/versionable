require 'test_helper'

class Versionable::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Versionable
  end
end
