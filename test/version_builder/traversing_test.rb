require 'test_helper'

class Versionable::TraversingTest < ActiveSupport::TestCase
  class Subject
    include Versionable::Traversing
  end

  test "it lists all versionable dependent-destroyed related records" do
    post = create(:post)
    comment_1 = create(:comment, post: post)
    comment_2 = create(:comment, post: post)
    photo = create(:photo, post: post)
    gallery = create(:gallery, post: post)
    category = create(:category, posts: [post])
    banner = create(:banner, category: category)

    assert_equal [
      post,
      comment_1,
      comment_2,
      photo,
      gallery,
      category,
      banner
    ], Subject.new.send(:traverse, post)
  end

  test "it skips excepted paths" do
    post = create(:post)
    create(:comment, post: post)
    create(:comment, post: post)
    photo = create(:photo, post: post)
    gallery = create(:gallery, post: post)
    category = create(:category, posts: [post])
    banner = create(:banner, category: category)

    assert_equal [
      post,
      photo,
      gallery,
      category
    ], Subject.new.send(:traverse, post, ["comments", "category.banners"])
  end

  test "it skips new (unsaved) records" do
    post = create(:post)
    build(:gallery, post: post)

    assert_equal [
      post
    ], Subject.new.send(:traverse, post)
  end
end
