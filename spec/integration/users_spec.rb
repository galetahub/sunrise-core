describe User do
  before(:all) do
    @admin = Factory.create(:admin_user)
  end
    
  it "sign in via admin" do
    visit new_user_session_path
    fill_in "user_email", :with => @admin.email
    fill_in "user_password", :with => 'password'
    click_button "user_submit"
  end
    
#  describe "administrator" do
#    
#    describe "GET /manage/users" do
#      it "displays users" do
#        visit manage_users_path
#        page.should have_content(@admin.email)
#      end
#    end
#    
#    describe "POST /manage/users" do
#      it "creates user" do
#        visit new_manage_user_path
#        fill_in "user_name", :with => "Test"
#        click_button "user_submit"
#        page.should have_content("Successfully added task.")
#        page.should have_content("mow lawn")
#      end
#    end
#  end
end
