require 'spec_helper'

describe PagesController do
  render_views
  
  before(:all) do
    @root = FactoryGirl.create(:structure_main)
  end
    
  context "page" do
    before(:each) { @page = FactoryGirl.create(:structure_page, :parent => @root) }
    
    it "should render show action" do
      get :show, :id => @page.slug
      
      assigns(:structure).should == @page
      
      response.should be_success
      response.should render_template('show')
    end
  end
end
