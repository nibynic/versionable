require 'test_helper'

class Versionable::TraversingTest < ActiveSupport::TestCase
  class Subject
    include Versionable::Traversing
  end

  test "it lists all versionable related records" do
    post = create(:post)
    comment_1 = create(:comment, post: post)
    comment_2 = create(:comment, post: post)
    photo_1 = create(:photo, post: post)
    gallery_1 = create(:gallery, post: post)
    post_2 = create(:post)
    category_1 = create(:category, posts: [post, post_2])

    assert_equal [
      post,
      comment_1,
      comment_2,
      photo_1,
      gallery_1,
      category_1,
      post_2
    ], Subject.new.send(:traverse, post)
  end

  test "it skips excepted paths" do
    post = create(:post)
    comment_1 = create(:comment, post: post)
    comment_2 = create(:comment, post: post)
    photo_1 = create(:photo, post: post)
    gallery_1 = create(:gallery, post: post)
    post_2 = create(:post)
    category_1 = create(:category, posts: [post, post_2])

    assert_equal [
      post,
      photo_1,
      gallery_1,
      category_1
    ], Subject.new.send(:traverse, post, ["comments", "category.posts"])
  end
end
