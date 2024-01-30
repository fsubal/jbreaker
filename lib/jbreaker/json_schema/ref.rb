# frozen_string_literal: true

require 'active_support/core_ext/string'

module Jbreaker
  module JsonSchema
    class Ref
      def initialize(target_file_name, **options)
        @target_file_name = target_file_name
        @options = options
      end

      def component_name
        @component_name ||= @target_file_name.camelize
      end

      def schema
        @schema ||= target_class.schema
      end

      def to_reference
        { '$ref': "#/components/schemas/#{component_name}", **options }
      end

      def to_definition
        { component_name => schema }
      end

      private

      def target_class
        @target_class ||= Jbreaker.require(@target_file_name)
      end
    end
  end
end
