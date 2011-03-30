# encoding: utf-8
module Sunrise
  module Models
    module User
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend,  ClassMethods
      end
      
      module ClassMethods
        def self.extended(base)
          base.class_eval do        
            has_many :roles, :dependent => :delete_all
            has_one :avatar, :as => :assetable, :dependent => :destroy, :autosave => true
            
            scope :with_role, lambda {|role| joins(:roles).where(["`roles`.role_type = ?", role.id]) }
            scope :admins, with_role(::RoleType.admin)
            
            before_validation :generate_login, :if => :has_login?
            before_create :set_default_role, :if => :roles_empty?
          end
        end
      end
      
      module InstanceMethods
        def manager?
	        has_role?(:manager)
	      end
	
	      def admin?
	        has_role?(:admin)
	      end
	
	      def has_role?(role_name)
	        role_symbols.include?(role_name.to_sym)
	      end
	      
	      def roles_empty?
	        self.roles.empty?
	      end
	      
	      def has_login?
	        respond_to?(:login)
	      end
	      	
	      def roles_attributes=(value)
          options = value || {}
          options.each do |k, v|
            create_or_destroy_role(k.to_i, v.to_i == 1)
          end
        end
	
	      def role_symbols
          (roles || []).map {|r| r.to_sym}
        end
        
        def current_role
          self.roles.first
        end
        
        def role_type_id
          if current_role
            current_role.role_type.id
          end
        end
        
        def role_type_id=(value)
          role_id = value.blank? ? nil : value.to_i
          
          if ::RoleType.all.map(&:id).include?(role_id)
            ::RoleType.all.each do |role_type|
              create_or_destroy_role(role_type.id, role_type.id == role_id)
            end
          end
        end
        
        def state
          return 'active' if active_for_authentication?
          return 'register' unless confirmed?
          return 'suspend' if access_locked?
          'pending'
        end
        
        def events_for_current_state
          events = []
          events << 'activate' if state == 'register'
          events
        end
        
        protected
          
          def set_default_role
            unless has_role?(:default)
              self.roles.build(:role_type => ::RoleType.default)
            end
          end
          
          def create_or_destroy_role(role_id, need_create = true)
            role = self.roles.detect { |r| r.role_type.id == role_id }
            if need_create
              role ||= self.roles.build(:role_type => ::RoleType.find(role_id))
            elsif !role.nil?
              self.roles.delete(role)
            end
          end
          
          def generate_login
            self.login ||= begin
              unless email.blank?
                tmp_login = email.split('@').first 
        		    tmp_login.parameterize.downcase.gsub(/[^A-Za-z0-9-]+/, '-').gsub(/-+/, '-')
        		  end
            end
          end
      end
    end
  end
end
