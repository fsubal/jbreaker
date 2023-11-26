# frozen_string_literal: true

require 'test_helper'

class DslTest < ActiveSupport::TestCase
  using Jbreaker::JsonSchema::Operator

  # rubocop:disable Metrics/BlockLength
  test 'it defines a JSON Schema' do
    t = Jbreaker::JsonSchema::Dsl.new

    assert_equal ({
      id: { type: :number },
      name: { type: :string, optional: true },
      description: { anyOf: [{ type: :string }, { type: :null }] },
      is_public: { type: :boolean },
      shop: {
        type: :object,
        properties: {
          id: { type: :number }
        }
      },
      tags: {
        type: :array,
        items: {
          type: :string
        }
      }
    }), {
      id: t.number,
      name: t.string?,
      description: t.string | t.null,
      is_public: t.boolean,
      shop: t.object({ id: t.number }),
      tags: t.array(t.string)
    }
  end
  # rubocop:enable Metrics/BlockLength
end
