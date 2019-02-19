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
      "id"          => "1",
      "last_name"   => "Keaton",
      "born_on"     => "1950-08-12"
    }, {
      "id"          => "1",
      "first_name"  => "Emily",
      "last_name"   => "Smith"
    })
  end

  test "it detects related record changes" do
    assert_equal [
      ["-", "correspondence_address", { "id" => "2", "street" => "Sit Rd." }],
      ["+", "correspondence_address", { "id" => "3", "street" => "Sit Rd." }],
      ["~", "phone_numbers[0].number", "111111111", "333333333"],
      ["-", "phone_numbers[1]", { "id" => "2", "number" => "222222222" }],
      ["+", "phone_numbers[1]", { "id" => "3", "number" => "222222222" }],
      ["~", "registered_address.street", "Nulla St", "Fusce Rd."]
    ], Subject.new.send(:diff, {
      "registered_address" => {
        "id"      => "1",
        "street"  => "Nulla St"
      },
      "correspondence_address" => {
        "id"      => "2",
        "street"  => "Sit Rd."
      },
      "phone_numbers" => [
        { "id" => "1", "number" => "111111111" },
        { "id" => "2", "number" => "222222222" }
      ]
    }, {
      "registered_address" => {
        "id"      => "1",
        "street"  => "Fusce Rd."
      },
      "correspondence_address" => {
        "id"      => "3",
        "street"  => "Sit Rd."
      },
      "phone_numbers" => [
        { "id" => "1", "number" => "333333333" },
        { "id" => "3", "number" => "222222222" }
      ]
    })
  end
end
