require 'spec_helper'

describe PagesController do
  render_views
  
  before(:all) do
    @root = Factory.create(:structure_main)
    @structure = Factory.create(:structure_page, :parent => @root)
    @page = Factory.create(:page, :structure => @structure)
  end
  
  context "anonymous user" do
    user_logout
    
    it "should render show action" do
      get :show, :id => @structure.slug
      
      assigns(:page).should == @page
      response.should render_template('show')
    end
    
    it "should render 404 page" do
      lambda {
        get :show, :id => 'wrong'
      }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
