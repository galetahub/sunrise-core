# encoding: utf-8
module Sunrise
  module Models
    module Structure
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend,  ClassMethods
      end
      
      module ClassMethods
        def self.extended(base)
          base.send(:include, Utils::Header)
          base.class_eval do
            enumerated_attribute :structure_type, :id_attribute => :kind
            enumerated_attribute :position_type, :id_attribute => :position
            
            validates_presence_of :title
            validates_numericality_of :position, :only_integer => true
            
            has_one :page, :dependent => :destroy
            
            scope :visible, where(:is_visible => true)
            scope :with_kind, proc {|structure_type| where(:kind => structure_type.id) }
            scope :with_depth, proc {|level| where(:depth => level.to_i) }
            scope :with_position, proc {|position_type| where(:position => position_type.id) }
          end
        end
        
        def find_by_permalink(value)
          value.to_s.is_int? ? find(value) : where(:slug => value.to_s).first
        end
      end
      
      module InstanceMethods
        def moveable?
          return true if new_record?
          !root?
        end
      end
    end
  end
end
