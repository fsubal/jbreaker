# frozen_string_literal: true

module Jbreaker
  module JsonSchema
    # Shorthand for defining JSON Schema in Ruby
    class Dsl
      def initialize; end

      %i[number string boolean null].each do |primitive|
        define_method primitive do |**options|
          { type: primitive, **options }
        end

        define_method "#{primitive}?" do |**options|
          { type: primitive, optional: true, **options }
        end
      end

      def ref(partial_path)
        { '$ref': partial_path }
      end

      def ref?(partial_path)
        { '$ref': partial_path, optional: true }
      end

      def array(items, **options)
        raise TypeError unless items.is_a? Hash

        { type: :array, items: items, **options }
      end

      def array?(items)
        array(items, optional: true, **options)
      end

      def object(properties, **options)
        raise TypeError unless properties.is_a? Hash

        { type: :object, properties: properties, **options }
      end

      def object?(properties, **options)
        object(properties, optional: true, **options)
      end
    end
  end
end
