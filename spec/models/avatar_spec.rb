require 'spec_helper'

describe Avatar do
  before(:all) do
    @avatar = Factory.build(:asset_avatar)
  end
  
  it "should create a new instance given valid attributes" do
    @avatar.save!
  end
  
  context "validations" do
    it "should not be valid without data" do
      pending "asset data validations dont work on presence_of"
      @avatar.data = nil
      @avatar.should_not be_valid
    end
    
    it "should not be valid with not image content-type" do
      @avatar.data_content_type = 'unknown type'
      @avatar.should_not be_valid
    end
    
    it "should not be valid with big size image" do
      @avatar = Factory.build(:asset_avatar_big)
      @avatar.should_not be_valid
      @avatar.errors[:data].first.should =~ /is\stoo\sbig/
    end
  end
  
  context "after create" do
    before(:each) do
      @avatar = Factory.create(:asset_avatar)
    end
    
    it "filename should be valid" do
      @avatar.filename.should == 'rails.png'
    end
    
    it "content-type should be valid" do
      @avatar.data_content_type.should == 'image/png'
    end
    
    it "file size should be valid" do
      @avatar.data_file_size.should == 6646
    end
    
    it "should be image" do
      @avatar.image?.should be_true
    end
    
    it "data_file_name should be valid" do
      @avatar.data_file_name.should == 'rails.png'
    end
    
    it "width and height should be valid" do
      if @avatar.has_dimensions?
        @avatar.width.should == 50
        @avatar.height.should == 64
      end 
    end
    
    it "urls should be valid" do
      @avatar.url.should == "/uploads/#{@avatar.class.to_s.underscore}/#{@avatar.id}/rails.png"
      @avatar.thumb_url.should == "/uploads/#{@avatar.class.to_s.underscore}/#{@avatar.id}/thumb_rails.png"
    end
    
  end
end
