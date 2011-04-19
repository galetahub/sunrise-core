class SunriseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :name, :limit => 150
      # t.string :login, :limit => 20, :null => false
      
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.confirmable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :time
      t.encryptable
      # t.token_authenticatable

      t.timestamps
    end
    
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :login,                :unique => true
    # add_index :users, :unlock_token,         :unique => true    
  end

  def self.down
    drop_table :users
  end
end
