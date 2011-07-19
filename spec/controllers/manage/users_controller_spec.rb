require 'spec_helper'

describe Manage::UsersController do
  render_views
  
  context "administrator" do
    login_admin
    
    before(:each) do
      @attrs = Factory.attributes_for(:default_user)
    end
    
    it "should render new action" do
      get :new
      response.should be_success
      response.should render_template("new")
    end
    
    it "should create new user" do
      lambda {
        post :create, :user => @attrs
      }.should change { User.defaults.count }.by(1)
    end
    
    it "should create user with redactor role" do
      post :create, :user => @attrs.merge(:role_type_id => RoleType.redactor.id)
      assigns(:user).should be_valid
      assigns(:user).role_type_id.should == RoleType.redactor.id
    end
    
    it "should not destroy self account" do
      controller.should_not_receive :destroy
      delete :destroy, :id => @admin.id
    end
    
    context "exists default user" do
      before(:each) do
        @user = Factory.create(:default_user)
      end
      
      it "should render index action" do
        get :index
        assigns(:users).should include(@user)
        response.should render_template('index')
      end
      
      it "should render edit action" do
        controller.should_receive :edit
        get :edit, :id => @user.id
      end
      
      it "should update user role" do
        put :update, :id => @user.id, :user => {:role_type_id => RoleType.redactor.id}
        assigns(:user).should be_valid
        assigns(:user).role_type_id.should == RoleType.redactor.id
        response.should redirect_to(manage_users_path)
      end
      
      it "should destroy user" do
        lambda {
          delete :destroy, :id => @user.id
        }.should change { User.defaults.count }.by(-1)
      end
    end
  end
  
  context "anonymous user" do
    user_logout
    
    it "should not render index action" do
      controller.should_not_receive :index
      get :index
    end
    
    it "should not render new action" do
      controller.should_not_receive :new
      get :new
    end
    
    it "should not render create action" do
      controller.should_not_receive :create
      post :create
    end
    
    context "with exists user" do
      before(:each) do
        @user = Factory.create(:default_user)
      end
      
      it "should not render edit action" do
        controller.should_not_receive :edit
        get :edit, :id => @user.id
      end
      
      it "should not render update action" do
        controller.should_not_receive :update
        put :update, :id => @user.id
      end
      
      it "should not render destroy action" do
        controller.should_not_receive :destroy
        delete :destroy, :id => @user.id
      end
    end
  end
end
