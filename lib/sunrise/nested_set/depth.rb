module Sunrise
  module NestedSet
    module Depth
      extend ActiveSupport::Concern

      module ClassMethods
        # Update cached_level attribute for all records tree
        def update_depth
          roots.each do |node|
            connection.execute("UPDATE #{quoted_table_name} a SET a.depth = \
              (SELECT count(*) - 1 FROM (SELECT * FROM #{quoted_table_name} WHERE #{scope_condition(node)}) AS b \
              WHERE #{scope_condition(node, 'a')} AND \
              (a.#{quoted_left_column_name} BETWEEN b.#{quoted_left_column_name} AND b.#{quoted_right_column_name}))
              WHERE #{scope_condition(node, 'a')}")
          end
        end
        
        def depth?
          column_names.include?("depth")
        end
        
        protected
        
          # Model scope conditions
          def scope_condition(node, table_name = nil)
            table_name ||= quoted_table_name

            scope_string = Array(acts_as_nested_set_options[:scope]).map do |c|
              "#{table_name}.#{connection.quote_column_name(c)} = #{node.send(c)}"
            end.join(" AND ")

            scope_string.blank? ? "1 = 1" : scope_string
          end
      end
      
      module InstanceMethods
        # Check is model has depth column
        def depth?
          self.class.depth?
        end

        # Update cached_level attribute
        def update_depth
          update_attribute(:depth, level)
        end
      end
    end
  end
end
