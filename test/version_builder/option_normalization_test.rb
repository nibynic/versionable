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

  test "it excludes created_at and updated_at" do
    assert_equal ({
      root: false,
      only: [:title],
      except: [:created_at, :updated_at]
    }), Subject.new.send(:normalize_options,
      only: [:title]
    )

    assert_equal ({
      root: false,
      except: [:title, :created_at, :updated_at]
    }), Subject.new.send(:normalize_options,
      except: [:title]
    )
  end

  test "it excludes created_at and updated_at in included relationships" do
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
          except: [:created_at, :updated_at]
        }
      },
      except: [:created_at, :updated_at]
    }), Subject.new.send(:normalize_options, 
      include: { comments: { include: :author } }
    )
  end
end
