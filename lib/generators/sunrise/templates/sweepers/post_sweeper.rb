class PostSweeper < ActionController::Caching::Sweeper
	observe Post
	
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
  	  expire_fragment(%r{/posts})
	    StructureSweeper.sweep!
	  end
end
