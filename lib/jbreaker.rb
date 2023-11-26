# frozen_string_literal: true

require 'jbreaker/version'
require 'jbreaker/railtie'
require 'jbreaker/template'
require 'jbreaker/json_schema/dsl'
require 'jbreaker/json_schema/operator'

module Jbreaker
  module_function

  class MissingDefinition < StandardError; end

  def registry
    @registry ||= {}
  end

  def clear_registry!
    @registry = {}
  end

  def define(view_context, &block)
    view_path = view_context.view_path

    registry[view_path] || Class.new(Jbreaker::Template, &block).tap do |new_klass|
      registry[view_path] = new_klass
    end
  end

  def resolve_class(view_path)
    registry.fetch(view_path)
  rescue KeyError => e
    raise MissingDefinition, e
  end
end
