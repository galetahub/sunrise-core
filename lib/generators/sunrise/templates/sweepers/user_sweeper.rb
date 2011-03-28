class UserSweeper < ActionController::Caching::Sweeper
	observe User
	
	def after_update(item)
		expire(item)
	end
	
	def after_destroy(item)
		expire(item)
	end
	
	private
	
	  def expire(item=nil)
  	  expire_fragment(%r{/users/#{item.id}*})
	  end
end
