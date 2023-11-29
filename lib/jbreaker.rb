# frozen_string_literal: true

require 'jbreaker/version'
require 'jbreaker/railtie'
require 'jbreaker/template'
require 'jbreaker/json_schema/dsl'

# :nodoc:
module Jbreaker
  include ActiveSupport::Configurable

  config_accessor :validate_json_schema_on_render, default: false

  module_function

  def registry
    @registry ||= {}
  end

  def clear_registry!
    @registry = {}
  end

  def define(&block)
    Class.new(Jbreaker::Template, &block)
  end

  def find_or_define(view_path, &block)
    registry[view_path] || define(&block).tap do |new_klass|
      registry[view_path] = new_klass
    end
  end
end

require 'jbuilder/railtie' if defined?(Rails)
