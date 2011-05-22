class Manage::AssetsController < Manage::BaseController
  before_filter :find_klass, :only => [:create, :sort]
  before_filter :find_asset, :only => [:destroy]
  
  respond_to :html, :xml
  
  authorize_resource
  
  def create
    @asset ||= @klass.new(params[:asset])
    
  	@asset.assetable_type = params[:assetable_type]
		@asset.assetable_id = params[:assetable_id] || 0
		@asset.guid = params[:guid]
  	@asset.data = params[:data_file]
  	@asset.user = current_user
    @asset.save
    
    respond_with(@asset) do |format|
      format.html { head :ok }
      format.xml { render :xml => @asset.to_xml }
    end
  end
  
  def destroy
    @asset.destroy
    
    respond_with(@asset) do |format|
      format.html { head :ok }
    end
  end
  
  def sort
    params[:asset].each_with_index do |id, index|
      @klass.move_to(index, id)
    end
    
    respond_with(@klass) do |format|
      format.html { head :ok }
    end
  end
  
  protected
  
    def find_asset
      @asset = Asset.find(params[:id])  
    end
    
    def find_klass
      c_names = []
      c_values = []
      
      unless params[:assetable_id].blank?
        c_names << "assetable_id = ?"
        c_values << params[:assetable_id].to_i
        
        c_names << "assetable_type = ?"
        c_values << params[:assetable_type]
      else
        c_names << "guid = ?"
        c_values << params[:guid]
      end
      
      @klass = params[:klass].blank? ? Asset : params[:klass].classify.constantize
      
      if params[:collection].blank?
        @asset = @klass.where([c_names.join(' AND ')] + c_values).first
      end
    end
end
