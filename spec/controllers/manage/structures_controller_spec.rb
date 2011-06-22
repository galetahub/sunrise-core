describe Manage::StructuresController do
  render_views
  
  before(:all) do
    Structure.create!(:title => "Main page", :slug => "main-page", :structure_type => StructureType.main)
  end
  
  context "administrator" do
    login_admin
    
    it "should render index action" do
      controller.should_receive :index
      get :index
    end
    
    it "should render new action" do
      get :new
      response.should be_success
      response.should render_template("new")
    end
    
    it "should create new user" do
      lambda {
        post :create, :structure => Factory.attributes_for(:structure)
      }.should change { Structure.count }.by(1)
    end
        
    context "exists structure" do
      before(:each) do
        @structure = Factory.create(:structure)
      end
      
      it "should render edit action" do
        controller.should_receive :edit
        get :edit, :id => @structure.id
      end
      
      it "should update structure" do
        put :update, :id => @structure.id, :structure => { :title => "Update" }
        assigns(:structure).should be_valid
        assigns(:structure).title.should == 'Update'
        response.should redirect_to(manage_structures_path)
      end
      
      it "should destroy user" do
        lambda {
          delete :destroy, :id => @structure.id
        }.should change { Structure.count }.by(-1)
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
