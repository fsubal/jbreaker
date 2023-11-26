# frozen_string_literal: true

require 'jbreaker/version'
require 'jbreaker/railtie'
require 'jbreaker/template'
require 'jbreaker/json_schema/dsl'
require 'jbreaker/json_schema/operator'

# :nodoc:
module Jbreaker
  class MissingDefinition < StandardError; end

  module_function

  # TODO: thread_mattr_accessor :validate_json_schema_on_render, default: false
  def validate_json_schema_on_render
    true
  end

  def registry
    @registry ||= {}
  end

  def clear_registry!
    @registry = {}
  end

  def define(view_path, &block)
    registry[view_path] || Class.new(Jbreaker::Template, &block).tap do |new_klass|
      new_klass.view_path = view_path
      registry[view_path] = new_klass
    end
  end

  def resolve_class(view_path)
    registry.fetch(view_path)
  rescue KeyError => e
    raise MissingDefinition, e
  end
end

require 'jbuilder/railtie' if defined?(Rails)
