# frozen_string_literal: true

require 'test_helper'

class DslTest < ActiveSupport::TestCase
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
        },
        required: [:id]
      },
      tags: {
        type: :array,
        items: {
          anyOf: [
            { type: :string },
            {
              type: :object,
              properties: {
                name: { type: :string }
              },
              required: [:name]
            }
          ]
        }
      }
    }), {
      id: t.number,
      name: t.string?,
      description: t.union(t.string, t.null),
      is_public: t.boolean,
      shop: t.object({ id: t.number }),
      tags: t.array(t.union(t.string, t.object({ name: t.string })))
    }
  end
  # rubocop:enable Metrics/BlockLength
end
