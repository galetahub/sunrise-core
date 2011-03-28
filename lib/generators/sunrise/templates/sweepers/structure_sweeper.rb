class StructureSweeper < ActionController::Caching::Sweeper
	observe Structure
	
	def after_create(item)
		expire(item)
	end
	
	def after_update(item)
		expire(item)
	end
	
	def after_destroy(item)
		expire(item)
	end
	
	# Clear all orders cache files
	def self.sweep!
	  cache_store = Rails.application.config.action_controller.cache_store
	  cache_store.clear if cache_store
	    
    Rails.logger.info("StructureSweeper clear all cache")
	end
	
	private
	
	  def expire(item=nil)
		  self.class.sweep!
	  end
end
