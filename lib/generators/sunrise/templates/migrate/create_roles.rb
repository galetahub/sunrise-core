class SunriseCreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.integer :role_type, :limit => 1, :default => 0
      t.integer :user_id, :null => false
      
      t.timestamps
    end
    
    add_index :roles, :user_id, :name => "fk_user"
  end

  def self.down
    drop_table :roles
  end
end
