module Sunrise
  module NestedSet
    module Descendants
      # Returns the number of nested children of this object.
      def descendants_count
        return (right - left - 1)/2
      end
      
      # Check if has descendants
      def has_descendants?
        !descendants_count.zero?
      end

      # Move node up or down (sort)
      def move_by_direction(ditection)
        return if ditection.blank?

        case ditection.to_sym
          when :up, :left then move_left
          when :down, :right then move_right
        end
      end
    end
  end
end
