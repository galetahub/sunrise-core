class Manage::UsersController < Manage::BaseController
  inherit_resources
  defaults :route_prefix => 'manage'
  
  load_and_authorize_resource  
  
  before_filter :check_params, :only => [:create, :update]
  
  with_options :only => [:index] do |i|
    i.respond_to :json, :csv
    
    i.has_scope :with_name, :as => :name
    i.has_scope :with_email, :as => :email
    i.has_scope :with_role, :as => :role
  end
  
  order_by :name, :created_at

  def index
    index! do |format|
      format.csv { send_data(User.to_csv, :filename => "users_#{Date.today}.csv", :type => "text/csv") }
      format.json do
        @users = User.with_email(params[:term]).includes(:avatar).select("users.id, users.name, users.email").limit(50)
        render :json => @users.as_json(:methods => [:avatar_small_url])
      end
    end
  end
  
  def create
    @user.attributes = params[:user]
    create! { manage_users_path } 
  end
  
  def update
    update!{ manage_users_path }
  end
  
  def destroy
    destroy!{ manage_users_path }
  end
  
  # POST /manage/users/1/activate
  def activate
    @user.confirm!    
    respond_with(@user, :location => manage_users_path)
  end
  
  # POST /manage/users/1/suspend
  def suspend
    @user.suspend! 
    respond_with(@user, :location => manage_users_path)
  end

  # POST /manage/users/1/unsuspend
  def unsuspend
    @user.unsuspend!
    respond_with(@user, :location => manage_users_path)
  end

  # POST /manage/users/1/unlock
  def unlock
    @user.unlock_access!
    respond_with(@user, :location => manage_users_path)
  end
  
  protected
    
    def collection
      @users = (@users || end_of_association_chain).order(search_filter.order).includes(:avatar).page(params[:page])
    end
    
    def check_params
      unless params[:user].blank?
        if params[:user][:password].blank?
          params[:user].delete(:password)
          params[:user].delete(:password_confirmation)
        end
        
        @user.accessible = :all
      end
    end
end
