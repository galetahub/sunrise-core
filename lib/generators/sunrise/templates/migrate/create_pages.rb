class SunriseCreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string    :title, :null => false
      t.text      :content
      t.integer   :structure_id, :null => false
      
      t.timestamps
    end
    
    add_index :pages, :structure_id, :name => "fk_pages"
  end

  def self.down
    drop_table :pages
  end
end
