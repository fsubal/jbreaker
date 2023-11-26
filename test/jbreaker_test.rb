require "test_helper"

class JbreakerTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Jbreaker::VERSION
  end

  test "it defines a class and caches" do
    # TODO: Use actual ActionView context class
    view_context_klass = Class.new do
      def view_path
        'shops/shop' # LIE. it is not actually a string(TODO).
      end
    end

    view_context = view_context_klass.new

    Jbreaker.define(view_context) do
      def render
        json.id 1
        json.name "John Doe"
      end
    end

    assert_operator Jbreaker.resolve_class('shops/shop'), '<', Jbreaker::Template
    assert_same Jbreaker.resolve_class('shops/shop'), Jbreaker.resolve_class('shops/shop'), "does not define twice"
  end
end
