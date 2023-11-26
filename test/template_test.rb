# frozen_string_literal: true

require 'test_helper'
require 'action_view/testing/resolvers'

class TemplateTest < ActiveSupport::TestCase
  TEMPLATE = <<~RUBY
    Jbreaker.define('/items/item.json.jbreaker') do
      def render
        json.id @item.id
        json.description simple_format(@item.description)
      end
    end
  RUBY

  setup do
    Item.create!(description: 'hello world!')
  end

  teardown { Jbreaker.clear_registry! }

  test 'it renders json' do
    item = Item.last
    context = view_context(assigns: { item: item })
    expected = { id: 1, description: '<p>hello world!</p>' }.to_json

    assert_equal expected, context.render(template: 'items/item')
  end

  private

  def view_context(assigns:)
    resolver = ActionView::FixtureResolver.new('items/item.json.jbreaker' => TEMPLATE)
    lookup_context = ActionView::LookupContext.new([resolver], {}, [''])
    controller = ActionView::TestCase::TestController.new

    ActionView::Base.with_empty_template_cache.new(lookup_context, assigns, controller)
  end
end
