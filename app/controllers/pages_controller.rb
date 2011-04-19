class PagesController < ApplicationController
  before_filter :find_structure
  before_filter :set_header
  
  caches_action :show, :layout => false
  
  def show
    @page = @structure.page || Page.new
    respond_with(@page)
  end
  
  protected
  
    def find_structure
      @structure = Structure.with_kind(StructureType.page).find_by_slug(params[:id])
      raise ActiveRecord::RecordNotFound.new("Structure #{params[:id]} not found") if @structure.nil?
    end
    
    def set_header      
      head_options(@structure)
    end
end
