# frozen_string_literal: true

require 'jbuilder'
require 'jbuilder/jbuilder_template'
require 'json-schema'

module Jbreaker
  # Base class for everything defined by Jbreaker.define()
  class Template
    delegate_missing_to :@view_context

    class_attribute :view_path

    def initialize(view_context)
      @view_context = view_context
      @view_context.assigns.each do |var_name, value|
        instance_variable_set("@#{var_name}", value)
      end
    end

    def json
      @json ||= JbuilderTemplate.new(@view_context)
    end

    def target!
      @json.target!
    end

    def self.t
      @t ||= Jbreaker::JsonSchema::Dsl.new
    end

    def self.validate!(json)
      return unless respond_to?(:schema)

      schema_hash = schema.with_indifferent_access

      unless schema_hash['type']
        raise TypeError, "JSON Schema does not have 'type' property on root. Did you forget to define?"
      end

      JSON::Validator.validate!(schema_hash, json, parse_data: true)
    end
  end
end
