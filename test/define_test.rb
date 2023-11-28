# frozen_string_literal: true

require 'test_helper'

class DefineTest < ActiveSupport::TestCase
  teardown { Jbreaker.clear_registry! }

  test 'it defines a class and caches' do
    subject = lambda do
      Jbreaker.find_or_define('/items/item.json.jbreaker') do
        def render
          json.id @item.id
          json.description simple_format(@item.description)
        end

        def self.schema
          {}
        end
      end
    end

    assert_operator subject.call, '<', Jbreaker::Template
    assert_same subject.call, subject.call, 'does not define twice'
    assert subject.call.method_defined? :render
    assert subject.call.respond_to? :schema
  end
end
