require 'spec_helper'

describe User do
  before(:all) do
    @user = Factory.create(:default_user)
  end
  
  it "should create a new instance given valid attributes" do
    @user.save!
  end
  
  context "validations" do
    it "should not be valid with invalid name" do
      @user.name = nil
      @user.should_not be_valid
    end
    
    it "should not be valid with invalid email" do
      @user.email = 'wrong'
      @user.should_not be_valid
    end
    
    it "should not be valid with invalid password" do
      @user.password = '123'
      @user.should_not be_valid
    end
  end
  
  context "after create" do
    before(:each) do
      @user.save
    end
    
    it "should set default role" do
      @user.role_type_id.should == RoleType.default.id
    end
  end
end
