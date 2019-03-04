require 'test_helper'
require "spy"

class Versionable::ActsAsVersionableTest < ActiveSupport::TestCase
  test "it defines store_versions method" do
    assert_equal true, create(:post).respond_to?(:store_versions)
    assert_equal false, create(:user).respond_to?(:store_versions)

    builder_spy = Spy.on(Versionable::VersionBuilder, :new).and_call_through
    store_spy = Spy.on_instance_method(Versionable::VersionBuilder, :store)
    user = create(:user)
    post = create(:post)
    post.store_versions(user)

    assert_equal [post], builder_spy.calls.first.args
    assert_equal [user], store_spy.calls.first.args

    builder_spy.unhook
    store_spy.unhook
  end

  test "it defines versions relationship" do
    assert_equal true, create(:post).respond_to?(:versions)
    assert_equal false, create(:user).respond_to?(:versions)
  end

  test "it stores versionable_options" do
    class Subject1 < ActiveRecord::Base
      acts_as_versionable only: :user
    end
    class Subject2 < Subject1
    end
    class Subject3 < ActiveRecord::Base
      acts_as_versionable only: :posts
    end

    assert_equal ({ only: :user }), Subject1.versionable_options
    assert_equal ({ only: :user }), Subject2.versionable_options
    assert_equal ({ only: :posts }), Subject3.versionable_options
  end

  test "it defines store_versions callbacks" do
    assert_nothing_raised do
      class Subject4 < ActiveRecord::Base
        acts_as_versionable
        before_store_versions :before_hook
        after_store_versions :after_hook
        around_store_versions :around_hook
      end
    end
  end
end
