# frozen_string_literal: true

module Roadie
  module Rails
    module Utils
      module_function
      # Combine two hashes, or return the non-nil hash if either is nil.
      # Returns nil if both are nil.
      def combine_hash(first, second)
        combine_nilable(first, second) do |a, b|
          a.merge(b)
        end
      end

      # Return a callable that will call both inputs. If either is nil, then
      # just return the other.
      #
      # The result from the second one will be the result of the combined
      # callable.
      #
      # ```ruby
      # combine_callable(-> { 1 }, -> { 2 }).call # => 2
      # combine_callable(-> { 1 }, nil).call # => 1
      # combine_callable(nil, nil).nil? # => true
      # ```
      def combine_callable(first, second)
        combine_nilable(first, second) do |a, b|
          lambda do |*args|
            a.call(*args)
            b.call(*args)
          end
        end
      end

      # Combine two Provider ducks into a ProviderList. If either is nil, pick
      # the non-nil value instead.
      def combine_providers(first, second)
        combine_nilable(first, second) do |a, b|
          ProviderList.new(a.to_a + Array.wrap(b))
        end
      end

      # Discard the nil value. If neither is nil, then yield both and return
      # the result from the block.
      #
      # ```ruby
      # combine_nilable(nil, 5) { |a, b| a+b } # => 5
      # combine_nilable(7, nil) { |a, b| a+b } # => 7
      # combine_nilable(nil, nil) { |a, b| a+b } # => nil
      # combine_nilable(7, 5) { |a, b| a+b } # => 12
      # ```
      def combine_nilable(first, second)
        if first && second
          yield first, second
        else
          first || second
        end
      end
    end
  end
end
