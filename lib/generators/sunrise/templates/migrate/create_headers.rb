class SunriseCreateHeaders < ActiveRecord::Migration
  def self.up
    create_table :headers do |t|
      t.string    :title
      t.string    :keywords
      t.text      :description
      
      t.string    :headerable_type, :limit => 30, :null => false
      t.integer   :headerable_id, :null => false
      
      t.timestamps
    end
    
    add_index :headers, [:headerable_type, :headerable_id], :uniq => true, :name => "fk_headerable"
  end

  def self.down
    drop_table :headers
  end
end
