require 'test_helper'
require "spy"

class Versionable::ActsAsVersionableTest < ActiveSupport::TestCase
  test "it defines store_versions method" do
    assert_equal true, create(:post).respond_to?(:store_versions)
    assert_equal false, create(:category).respond_to?(:store_versions)

    builder_spy = Spy.on(Versionable::VersionBuilder, :new).and_call_through
    store_spy = Spy.on_instance_method(Versionable::VersionBuilder, :store)
    user = create(:user)
    post = create(:post)
    post.store_versions(user)

    assert_equal [post, user], builder_spy.calls.first.args
    assert_equal 1, store_spy.calls.length

    builder_spy.unhook
    store_spy.unhook
  end

  test "it defines versions relationship" do
    assert_equal true, create(:post).respond_to?(:versions)
    assert_equal false, create(:category).respond_to?(:versions)
  end

  test "it stores versionable_options" do
    class Subject < ActiveRecord::Base
      acts_as_versionable only: :user
    end

    assert_equal ({ only: :user }), Subject.versionable_options
  end
end
