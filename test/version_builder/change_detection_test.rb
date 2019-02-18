require 'test_helper'

class Versionable::ChangeDetectionTest < ActiveSupport::TestCase
  class Subject
    include Versionable::ChangeDetection
  end

  test "it detects attribute changes" do
    assert_equal [
      ["-", "born_on", "1950-08-12"],
      ["~", "last_name", "Keaton", "Smith"],
      ["+", "first_name", "Emily"]
    ], Subject.new.send(:diff, {
      last_name: "Keaton",
      born_on: "1950-08-12"
    }, {
      first_name: "Emily",
      last_name: "Smith"
    })
  end
end
