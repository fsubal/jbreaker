# frozen_string_literal: true

require 'jbuilder'
require 'jbuilder/jbuilder_template'

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
  end
end
