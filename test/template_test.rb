# frozen_string_literal: true

require 'test_helper'
require 'action_view/testing/resolvers'

class TemplateTest < ActiveSupport::TestCase
  setup do
    Item.create!(description: 'hello world!')
  end

  teardown { Jbreaker.clear_registry! }

  TEMPLATE_SHOW = <<~RUBY
    Jbreaker.define('/items/show.json.jbreaker') do
      def render
        json.id @item.id
        json.description simple_format(@item.description)
      end

      def self.schema
        t.object({
          id: t.number,
          description: t.string
        })
      end
    end
  RUBY

  test 'it renders json (show.json)' do
    context = view_context(assigns: { item: Item.last })
    expected = { id: 1, description: '<p>hello world!</p>' }.to_json
    actual = context.render(template: 'items/show')

    assert_equal expected, actual
  end

  TEMPLATE_PARTIAL = <<~RUBY
    Jbreaker.define('/items/_item.json.jbreaker') do
      def render(item:)
        json.id item.id
        json.description simple_format(item.description)
      end
    end
  RUBY

  test 'it renders json (partial)' do
    expected = { id: 1, description: '<p>hello world!</p>' }.to_json

    assert_equal expected, view_context.render(template: 'items/_item', locals: { item: Item.last })
  end

  private

  def view_context(assigns: {})
    resolver = ActionView::FixtureResolver.new(
      'items/show.json.jbreaker' => TEMPLATE_SHOW,
      'items/_item.json.jbreaker' => TEMPLATE_PARTIAL
    )
    lookup_context = ActionView::LookupContext.new([resolver], {}, [''])
    controller = ActionView::TestCase::TestController.new

    ActionView::Base.with_empty_template_cache.new(lookup_context, assigns, controller)
  end
end
