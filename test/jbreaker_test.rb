require 'test_helper'

class JbreakerTest < ActiveSupport::TestCase
  setup do
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
        json.name 'John Doe'
      end

      def self.schema
        {}
      end
    end
  end

  teardown { Jbreaker.clear_registry! }

  test 'it defines a class and caches' do
    subject = Jbreaker.resolve_class('shops/shop')

    assert_operator subject, '<', Jbreaker::Template
    assert_same subject, Jbreaker.resolve_class('shops/shop'), 'does not define twice'
    assert subject.method_defined? :render
    assert subject.respond_to? :schema
  end
end
