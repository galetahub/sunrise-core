# encoding: utf-8
module Sunrise
  module Models
    class StructureType
      def initialize(value)
        @kind = value
      end
      attr_reader :kind
      
      def title
        I18n.t(@kind, :scope => [:manage, :structure, :kind])
      end
    end
  end
end
