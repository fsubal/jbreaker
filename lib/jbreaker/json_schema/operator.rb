# frozen_string_literal: true

module Jbreaker
  module JsonSchema
    # Allow use of | and & for Hash, which are convenient for schema definition
    module Operator
      refine Hash do
        def |(other)
          raise TypeError, 'Hash#| only accepts another Hash' unless other.is_a? Hash

          if key? :anyOf
            self[:anyOf].push(other)
          else
            { anyOf: [self, other] }
          end
        end

        def &(other)
          raise TypeError, 'Hash#& only accepts another Hash' unless other.is_a? Hash

          if key? :allOf
            self[:allOf].push(other)
          else
            { allOf: [self, other] }
          end
        end
      end
    end
  end
end
