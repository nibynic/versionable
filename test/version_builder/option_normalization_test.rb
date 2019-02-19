require 'test_helper'

class Versionable::OptionNormalizationTest < ActiveSupport::TestCase
  class Subject
    include Versionable::OptionNormalization
  end

  test "it removes root" do
    assert_equal ({
      root: false,
      except: [:created_at, :updated_at]
    }), Subject.new.send(:normalize_options, root: "model")
  end

  test "it deeply excludes created_at, updated_at and foreign keys of already included relationships" do
    assert_equal ({
      root: false,
      include: {
        comments: {
          except: [:created_at, :updated_at]
        }
      },
      except: [:created_at, :updated_at]
    }), Subject.new.send(:normalize_options,
      include: :comments
    )

    assert_equal ({
      root: false,
      include: {
        comments: {
          include: {
            author: {
              except: [:created_at, :updated_at]
            }
          },
          except: [:created_at, :updated_at, :author_id]
        }
      },
      except: [:created_at, :updated_at]
    }), Subject.new.send(:normalize_options,
      include: { comments: { include: :author } }
    )
  end

  test "it lists included paths" do
    assert_equal [
      "comments"
    ], Subject.new.send(:get_included_paths,
      include: :comments
    )

    assert_equal [
      "comments",
      "comments.author"
    ], Subject.new.send(:get_included_paths,
      include: { comments: { include: :author } }
    )
  end
end
