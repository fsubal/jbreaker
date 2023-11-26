# frozen_string_literal: true

require 'test_helper'

class DefineTest < ActiveSupport::TestCase
  setup do
    Jbreaker.define('/items/item.json.jbreaker') do
      def render
        json.id @item.id
        json.description simple_format(@item.description)
      end

      def self.schema
        {}
      end
    end
  end

  teardown { Jbreaker.clear_registry! }

  test 'it defines a class and caches' do
    subject = Jbreaker.resolve_class('/items/item.json.jbreaker')

    assert_operator subject, '<', Jbreaker::Template
    assert_same subject, Jbreaker.resolve_class('/items/item.json.jbreaker'), 'does not define twice'
    assert subject.method_defined? :render
    assert subject.respond_to? :schema
  end
end
