class SunriseCreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string  :data_file_name, :null => false
      t.string  :data_content_type
      t.integer :data_file_size
      
      t.integer :assetable_id, :null => false
		  t.string  :assetable_type, :limit => 25, :null => false
      t.string  :type, :limit => 25
      t.string  :guid, :limit => 10
		  
		  t.integer :locale, :limit => 1, :default => 0
		  t.integer :user_id
		  t.integer :sort_order, :default => 0
		  
      t.timestamps
    end
    
    add_index "assets", ["assetable_type", "type", "assetable_id"]
		add_index "assets", ["assetable_type", "assetable_id"]
		add_index "assets", ["user_id"]
  end

  def self.down
    drop_table :assets
  end
end
