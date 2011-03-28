module Manage::AssetsHelper
  
  def manage_assets_path_with_session_information(klass = 'Asset', options = {})
    options = { :format => :xml, :protocol => "http://" }.merge(options)
    session_key = Rails.application.config.send(:session_options)[:key]
    
    options[session_key] = Rack::Utils.escape(cookies[session_key])
    options[:klass] = klass
    
    if protect_against_forgery?
      options[request_forgery_protection_token] = Rack::Utils.escape(form_authenticity_token)
    end
    
    manage_assets_url(options)
  end
end
