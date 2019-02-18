require 'test_helper'

class Versionable::VersionBuilderTest < ActiveSupport::TestCase
  test "it detects create event" do
    post = create(:post, title: "My post", content: "hello!")
    user = create(:user)

    version = Versionable::VersionBuilder.new(post, user).store

    assert_equal "create", version.event
    assert_equal user, version.author
    assert_equal version, post.versions.last
    assert_equal [
      ["+", "content", "hello!"],
      ["+", "id", post.id],
      ["+", "title", "My post"]
    ], version.data_changes
    assert_equal ({
      "id" => post.id,
      "title" => "My post",
      "content" => "hello!"
    }), version.data_snapshot
  end

  test "it detects update event" do
    post = create(:post, title: "My post", content: "hello!")
    user = create(:user)

    Versionable::VersionBuilder.new(post, user).store

    post.update_attributes(title: "New title")

    version = Versionable::VersionBuilder.new(post, user).store

    assert_equal "update", version.event
    assert_equal user, version.author
    assert_equal version, post.versions.last
    assert_equal [
      ["~", "title", "My post", "New title"]
    ], version.data_changes
    assert_equal ({
      "id" => post.id,
      "title" => "New title",
      "content" => "hello!"
    }), version.data_snapshot
  end
end
