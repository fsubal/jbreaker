# frozen_string_literal: true

module Jbreaker
  # Base class for everything defined by Jbreaker.define()
  class Template
    delegate_missing_to :@view_context

    attr_reader :json

    def initialize(view_context)
      @view_context = view_context
      @view_context.assigns.each do |var_name, value|
        instance_variable_set("@#{var_name}", value)
      end

      @json = JbuilderTemplate.new(view_context)
    end

    def self.t
      @t ||= Jbreaker::JsonSchema::Dsl.new
    end
  end
end
