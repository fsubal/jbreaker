# frozen_string_literal: true

module Jbreaker
  # ActionView adapter for jbreaker
  class Handler
    cattr_accessor :default_format

    self.default_format = :json

    def self.call(template, source = nil)
      source ||= template.source

      "#{source};" \
      "klass = Jbreaker.resolve_class('#{template.identifier}');" \
      'template = klass.new(self);' \
      'template.render(**local_assigns);' \
      'result = template.target!;' \
      'klass.validate!(result) if Jbreaker.validate_json_schema_on_render;' \
      'result;'
    end

    def self.handles_encoding?
      true
    end
  end
end