require 'spec_helper'

describe Manage::SettingsController do
  render_views
  
  context "administrator" do
    login_admin
    
    it "should render index action" do
      get :index
      response.should be_success
      response.should render_template("index")
    end
    
    it "should update system settings" do
      post :create, :settings => { :mailer => {:subject_prefix => "Test"} }
      Sunrise::SystemSettings.mailer.subject_prefix.should == "Test"
    end
  end
  
  context "anonymous user" do
    user_logout
    
    it "should not render index action" do
      controller.should_not_receive :index
      get :index
    end
    
    it "should not render create action" do
      controller.should_not_receive :create
      post :create
    end
  end
end
