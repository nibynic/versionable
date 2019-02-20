require 'test_helper'
require "spy"

class Versionable::VersionBuilderTest < ActiveSupport::TestCase
  test "it doesn't create version if no changes were detected" do
    post = create(:post, title: "My post", content: "hello!")
    user = create(:user)

    Versionable::VersionBuilder.new(post).store(user)
    versions = Versionable::VersionBuilder.new(post).store(user)

    assert_equal 0, versions.length
    assert_equal 1, post.versions.count
  end

  test "it detects create event" do
    post = create(:post, title: "My post", content: "hello!")
    user = create(:user)

    version = Versionable::VersionBuilder.new(post).store(user).first

    assert_equal "create", version.event
    assert_equal user, version.author
    assert_equal version, post.versions.last
    assert_equal [
      ["+", "category_id", nil],
      ["+", "comments", []],
      ["+", "content", "hello!"],
      ["+", "id", post.id],
      ["+", "title", "My post"]
    ], version.data_changes
    assert_equal ({
      "id"          => post.id,
      "title"       => "My post",
      "content"     => "hello!",
      "category_id" => nil,
      "comments"    => []
    }), version.data_snapshot

    assert_equal ({
      "Post" => 1
    }), Versionable::Version.group(:versionable_type).count
  end

  test "it detects update event" do
    post = create(:post, title: "My post", content: "hello!")
    user = create(:user)

    Versionable::VersionBuilder.new(post).store(user)

    post.update_attributes(title: "New title")

    version = Versionable::VersionBuilder.new(post).store(user).first

    assert_equal "update", version.event
    assert_equal user, version.author
    assert_equal version, post.versions.last
    assert_equal [
      ["~", "title", "My post", "New title"]
    ], version.data_changes
    assert_equal ({
      "id"          => post.id,
      "title"       => "New title",
      "content"     => "hello!",
      "category_id" => nil,
      "comments"    => []
    }), version.data_snapshot

    assert_equal ({
      "Post" => 2
    }), Versionable::Version.group(:versionable_type).count
  end

  test "it detects destroy event" do
    post = create(:post, title: "My post", content: "hello!")
    user = create(:user)

    Versionable::VersionBuilder.new(post).store(user)

    post.destroy

    version = Versionable::VersionBuilder.new(post).store(user).first

    assert_equal "destroy", version.event
    assert_equal user, version.author
    assert_equal version, post.versions.order(:created_at).last
    assert_equal [], version.data_changes
    assert_equal ({
      "id"          => post.id,
      "title"       => "My post",
      "content"     => "hello!",
      "category_id" => nil,
      "comments"    => []
    }), version.data_snapshot

    assert_equal ({
      "Post" => 2
    }), Versionable::Version.group(:versionable_type).count
  end

  test "it detects changes in related records" do
    post = create(:post)
    # has_many nested
    comment_1 = create(:comment, post: post)
    comment_2 = create(:comment, post: post)
    # has_many standalone
    photo_1 = create(:photo, post: post)
    # belongs_to nested
    gallery_1 = create(:gallery, post: post)
    # belongs_to standalone
    category_1 = create(:category, posts: [post])
    user = create(:user)

    Versionable::VersionBuilder.new(post).store(user)

    comment_1.update_attributes(content: "New content")
    comment_2.destroy
    comment_3 = create(:comment, post: post)
    photo_1.destroy
    photo_2 = create(:photo, post: post)
    gallery_1.destroy
    gallery_2 = create(:gallery, post: post)
    category_1.destroy
    category_2 = create(:category, posts: [post])

    version = Versionable::VersionBuilder.new(post).store(user).first

    assert_equal "update", version.event
    assert_equal user, version.author
    assert_equal version, post.versions.last
    assert_equal [
      ["~", "category_id", category_1.id, category_2.id],
      ["~", "comments[0].content", "Comment content", "New content"],
      ["-", "comments[1]", { "id" => comment_2.id, "post_id" => post.id, "author_id" => comment_2.author_id, "content" => "Comment content"}],
      ["+", "comments[1]", { "id" => comment_3.id, "post_id" => post.id, "author_id" => comment_3.author_id, "content" => "Comment content"}],
      ["-", "gallery", { "id" => gallery_1.id, "name" => "Gallery name" }],
      ["+", "gallery", { "id" => gallery_2.id, "name" => "Gallery name" }]
    ], version.data_changes
    assert_equal ({
      "id"          => post.id,
      "title"       => "Post title",
      "content"     => "Post content",
      "category_id" => category_2.id,
      "comments"    => [
        { "id" => comment_1.id, "post_id" => post.id, "author_id" => comment_1.author_id, "content" => "New content" },
        { "id" => comment_3.id, "post_id" => post.id, "author_id" => comment_3.author_id, "content" => "Comment content" }
      ],
      "gallery"     => {
        "id"    => gallery_2.id,
        "name"  => "Gallery name"
      }
    }), version.data_snapshot

    assert_equal ({
      "Post" => 2,
      "Category" => 2,
      "Photo" => 2
    }), Versionable::Version.group(:versionable_type).count
  end

  test "it detects destruction of related standalone records" do
    post = create(:post)
    # has_many nested
    comment_1 = create(:comment, post: post)
    comment_2 = create(:comment, post: post)
    # has_many standalone
    photo_1 = create(:photo, post: post)
    # belongs_to nested
    gallery_1 = create(:gallery, post: post)
    # belongs_to standalone
    category_1 = create(:category, posts: [post])
    user = create(:user)

    Versionable::VersionBuilder.new(post).store(user)

    post.destroy
    post.store_versions(user)

    category_version = category_1.versions.last

    assert_equal "destroy", category_version.event
    assert_equal user, category_version.author
    assert_equal [], category_version.data_changes
    assert_equal ({
      "id"      => category_1.id,
      "name"    => "Category name"
    }), category_version.data_snapshot

    photo_version = photo_1.versions.last

    assert_equal "destroy", photo_version.event
    assert_equal user, photo_version.author
    assert_equal [], photo_version.data_changes
    assert_equal ({
      "id"      => photo_1.id,
      "src"     => "Photo src",
      "post_id" => post.id
    }), photo_version.data_snapshot

    assert_equal ({
      "Post" => 2,
      "Category" => 2,
      "Photo" => 2
    }), Versionable::Version.group(:versionable_type).count
  end

  test "it uses always parent record" do
    post = create(:post)
    comment = create(:comment, post: post)
    user = create(:user)
    gallery = create(:gallery)

    get_parent_spy = Spy.on_instance_method(Versionable::VersionBuilder, :get_parent).and_return(gallery)

    version = Versionable::VersionBuilder.new(comment).store(user).first

    assert_equal [comment], get_parent_spy.calls.first.args
    assert_equal gallery, version.versionable
    
    get_parent_spy.unhook
  end
end
