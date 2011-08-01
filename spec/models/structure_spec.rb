require 'spec_helper'

describe Structure do
  before(:all) do
    @root = Factory.create(:structure_main)
    @structure = Factory.build(:structure_page, :parent => @root)
  end
  
  it "should create a new instance given valid attributes" do
    @structure.save!
  end
  
  context "validations" do
    it "should not be valid with invalid title" do
      @structure.title = nil
      @structure.should_not be_valid
    end
    
    it "should not be valid with invalid position" do
      @structure.position = 'wrong'
      @structure.should_not be_valid
    end
    
    it "should not be valid with taken slug" do
      @structure.slug = 'main-page'
      @structure.should_not be_valid
    end
  end
  
  context "acts_as_nested_set" do
    before(:each) do
      @structure.save
      @structure.reload
      @root.reload
    end
    
    it "should set depth column" do
      @structure.depth.should == @structure.level
    end
    
    it "should set parent model" do
      @structure.parent.should == @root
    end
    
    it "should count descendants" do
      @structure.descendants_count.should == 0
      @root.descendants_count.should == 1
    end
    
    it 'should calc depth column' do
      st = Factory.build(:structure_page, :parent => nil)
      st.parent_id = @structure.id
      st.save
      
      st.depth.should == 2
    end
  end
  
  context "class methods" do
    before(:each) do
      @structure.save!
    end
    
    it "should find structure by permalink" do
      Structure.find_by_permalink(@structure.id).should == @structure
      Structure.find_by_permalink(@structure.slug).should == @structure
    end
    
    it "should not find structure with wrong permalink" do
      Structure.find_by_permalink(nil).should be_nil
      Structure.find_by_permalink('wrong').should be_nil
      Structure.find_by_permalink(Time.now.to_i).should be_nil
    end
    
    it "should raise exception if structure not found" do
      lambda {
        Structure.find_by_permalink!('wrong')
      }.should raise_exception ActiveRecord::RecordNotFound
      
      Structure.find_by_permalink!(@structure.slug).should == @structure
    end
  end
end
