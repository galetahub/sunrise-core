class Manage::AssetsController < Manage::BaseController
  before_filter :find_klass, :only => [:create, :sort]
  before_filter :find_asset, :only => [:destroy]
  
  respond_to :html, :xml
  
  authorize_resource
  
  def create
    @asset = @klass.new(params[:asset])
    
  	@asset.assetable_type = params[:assetable_type]
		@asset.assetable_id = params[:assetable_id] || 0
		@asset.guid = params[:guid]
  	@asset.data = params[:data]
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
      format.xml { render :xml => @asset.to_xml }
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
      @klass = params[:klass].blank? ? Asset : params[:klass].classify.constantize
    end
end
