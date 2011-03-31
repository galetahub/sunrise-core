module Sunrise
  class Plugins < Array

    def initialize
      @plugins = []
    end

    def find_by_name(name)
      self.detect { |plugin| plugin.name == name.to_s.downcase }
    end
    alias :[] :find_by_name

    def find_by_title(title)
      self.detect { |plugin| plugin.title == title }
    end

    def menu(value)
      self.select { |p| p.menu == value.to_s.downcase }
    end

    def names
      self.map(&:name)
    end

    def titles
      self.map(&:title)
    end

    class << self
      def active
        @active_plugins ||= self.new
      end

      def registered
        @registered_plugins ||= self.new
      end

      def activate(name)
        active << registered[name] if registered[name] && !active[name]
      end

      def deactivate(name)
        active.delete_if {|p| p.name == name}
      end

      def set_active(names)
        @active_plugins = self.new

        names.each do |name|
          activate(name)
        end
      end
    end

  end
end
