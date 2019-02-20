require 'test_helper'

module Versionable::ParentFinding
  class Subject
    include Versionable::ParentFinding
  end

  class SimpleTest < ActiveSupport::TestCase
    test "it finds parent by method name" do
      post = create(:post)
      comment = create(:comment, post: post)
      user = create(:user)

      # parent: :post

      assert_equal post, Subject.new.send(:get_parent, comment)
    end

    test "it finds parent by lambda" do
      post = create(:post)
      gallery = create(:gallery, post: post)
      user = create(:user)

      # parent: -> { post }

      assert_equal post, Subject.new.send(:get_parent, gallery)
    end
  end

  class NestedTest < ActiveSupport::TestCase
    class Post < ActiveRecord::Base
      acts_as_versionable include: { comments: { include: :author }}
      has_many :comments, class_name: "NestedTest::Comment"
    end

    class Comment < ActiveRecord::Base
      acts_as_versionable parent: :post
      belongs_to :post, class_name: "NestedTest::Post"
      belongs_to :author, class_name: "NestedTest::User"
    end

    class User < ActiveRecord::Base
      acts_as_versionable parent: -> { comments.first }
      has_many :comments, foreign_key: :author_id, class_name: "NestedTest::Comment"
    end

    test "it resolves parent chain" do
      post = create(:post)
      comment = create(:comment, post: post)
      user = create(:user, comments: [comment])

      post = post.becomes(NestedTest::Post)
      user = user.becomes(NestedTest::User)

      assert_equal post, Subject.new.send(:get_parent, user)
    end
  end

  class LoopTest < ActiveSupport::TestCase
    class Post < ActiveRecord::Base
      acts_as_versionable parent: -> { comments.first }
      has_many :comments, class_name: "LoopTest::Comment"
    end

    class Comment < ActiveRecord::Base
      acts_as_versionable parent: :post
      belongs_to :post, class_name: "LoopTest::Post"
      belongs_to :author, class_name: "LoopTest::User"
    end

    class User < ActiveRecord::Base
      acts_as_versionable parent: -> { comments.first }
      has_many :comments, foreign_key: :author_id, class_name: "LoopTest::Comment"
    end

    test "it detects parent chain loops" do
      post = create(:post)
      comment = create(:comment, post: post)
      user = create(:user, comments: [comment])

      user = user.becomes(LoopTest::User)

      assert_raise Subject::InfiniteParentLoopError do
        Subject.new.send(:get_parent, user)
      end
    end
  end
end
