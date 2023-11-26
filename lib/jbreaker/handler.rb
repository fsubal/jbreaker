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
      'template.target!;'
    end

    def self.handles_encoding?
      true
    end
  end
end
