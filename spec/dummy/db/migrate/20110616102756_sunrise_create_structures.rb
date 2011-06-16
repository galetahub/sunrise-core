class SunriseCreateStructures < ActiveRecord::Migration
  def self.up
    create_table :structures do |t|
      t.string    :title, :null => false
      t.string    :slug, :null => false, :limit => 25
      t.integer   :kind, :limit => 1, :default => 0
      t.integer   :position, :limit => 2, :default => 0
      t.boolean   :is_visible, :default => true
      t.string    :redirect_url
      
      t.integer  "parent_id"
      t.integer  "lft",                          :default => 0
      t.integer  "rgt",                          :default => 0
      t.integer  "depth",                        :default => 0
      
      t.timestamps
    end
    
    add_index :structures, [:kind, :slug], :uniq => true
    add_index :structures, :parent_id
    add_index :structures, [:lft, :rgt]
  end

  def self.down
    drop_table :structures
  end
end
