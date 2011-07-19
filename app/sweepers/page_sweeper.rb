class PageSweeper < ActionController::Caching::Sweeper
	observe Page
	
	def after_create(item)
		expire(item)
	end
	
	def after_update(item)
		expire(item)
	end
	
	def after_destroy(item)
		expire(item)
	end
	
	private
	
	  def expire(item=nil)
  	  Sunrise::Utils.clear_cache
	  end
end
