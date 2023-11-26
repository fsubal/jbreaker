module Jbreaker
  module JsonSchema
    class Dsl
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
        Jbreaker::JsonSchema::DSL.new
      end
    end
  end
end
