# encoding: utf-8
module Sunrise
  module Models
    class PositionType
      def initialize(code)
        @code = code.to_sym
      end
      attr_reader :code
      
      def title
        I18n.t(@code, :scope => [:manage, :structure, :position])
      end  
    end
  end
end
