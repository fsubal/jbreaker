# frozen_string_literal: true

require 'test_helper'

class ConfigureTest < ActiveSupport::TestCase
  Klass = Jbreaker.define do
    def render
      json.id 1
    end

    def self.schema
      t.object({ id: t.null })
    end
  end

  setup do
    @previous = Jbreaker.validate_json_schema_on_render
  end

  teardown do
    Jbreaker.configure do |config|
      config.validate_json_schema_on_render = @previous
    end
  end

  test 'should raise' do
    Jbreaker.configure do |config|
      config.validate_json_schema_on_render = true
    end

    template = Klass.new(view_context)

    assert_raises JSON::Schema::ValidationError do
      template.render
      template.target!
    end
  end

  test 'should not raise' do
    Jbreaker.configure do |config|
      config.validate_json_schema_on_render = false
    end

    template = Klass.new(view_context)
    template.render

    assert_equal({ id: 1 }.to_json, template.target!)
  end

  private

  def view_context
    resolver = ActionView::FixtureResolver.new
    lookup_context = ActionView::LookupContext.new([resolver], {}, [''])
    controller = ActionView::TestCase::TestController.new

    ActionView::Base.with_empty_template_cache.new(lookup_context, {}, controller)
  end
end
