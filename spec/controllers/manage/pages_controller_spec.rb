require 'spec_helper'

describe Manage::PagesController do
  render_views
  
  before(:all) do
    @root = Factory.create(:structure_main)
    @structure = Factory.create(:structure_page, :parent => @root)
  end
  
  context "administrator" do
    login_admin
    
    it "should render edit action" do
      get :edit, :structure_id => @structure.id
      response.should be_success
      response.should render_template("new")
    end
    
    it "should create new page" do
      lambda {
        post :create, :structure_id => @structure.id, :page => Factory.attributes_for(:page)
      }.should change { Page.count }.by(1)
    end
        
    context "exists page" do
      before(:each) do
        @page = Factory.create(:page, :structure => @structure)
      end
      
      it "should call edit action" do
        controller.should_receive :edit
        get :edit, :structure_id => @structure.id
      end
      
      it "should render edit action" do
        get :edit, :structure_id => @structure.id
        response.should be_success
        response.should render_template("edit")
      end
      
      it "should update page" do
        put :update, :structure_id => @structure.id, :page => { :title => "Update" }
        assigns(:page).should be_valid
        assigns(:page).title.should == 'Update'
        response.should redirect_to(manage_structures_path)
      end
    end
  end
  
  context "anonymous user" do
    user_logout
    
    it "should not render create action" do
      controller.should_not_receive :create
      post :create, :structure_id => @structure.id
    end
    
    context "with exists page" do
      before(:each) do
        @page = Factory.create(:page, :structure => @structure)
      end
      
      it "should not render edit action" do
        controller.should_not_receive :edit
        get :edit, :structure_id => @structure.id
      end
      
      it "should not render update action" do
        controller.should_not_receive :update
        put :update, :structure_id => @structure.id
      end
    end
  end
end
