require 'spec_helper'

describe Manage::AssetsController do
  render_views
  
  after(:all) do
    Avatar.destroy_all
  end
  
  context "administrator" do
    login_admin
    
    before(:each) do
      @attrs = { 
        :assetable_type => @admin.class.name, 
        :assetable_id => @admin.id, 
        :data => fixture_file_upload('files/rails.png', 'image/png')
      }
    end
    
    it "should create new asset" do
      lambda {
        post :create, @attrs.merge(:klass => "Avatar")
      }.should change { Avatar.count }.by(1)
    end
    
    it "should not create asset with invalid params" do
      lambda {
        post :create, @attrs.merge(:data => nil, :klass => "Avatar")
      }.should_not change { Avatar.count }
    end
    
    context "exists avatar" do
      before(:each) do
        @avatar = @admin.create_avatar(:data => @attrs[:data])
      end
      
      it "should destroy avatar" do
        lambda {
          delete :destroy, :id => @avatar.id
        }.should change { Avatar.count }.by(-1)
      end
    end
  end
  
  context "anonymous user" do
    user_logout
    
    it "should not render create action" do
      controller.should_not_receive :create
      post :create, :klass => "Avatar"
    end
    
    context "with avatar" do
      before(:each) do
        @avatar = Factory.create(:asset_avatar)
      end
      
      it "should not render destroy action" do
        controller.should_not_receive :destroy
        delete :destroy, :id => @avatar.id
      end
    end
  end
end
