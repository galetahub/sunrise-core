# Structure tree
Sunrise::Plugin.register :structures do |plugin|
  plugin.model = 'sunrise/models/structure'
  plugin.menu = 'main'
end

# Users
Sunrise::Plugin.register :users do |plugin|
  plugin.model = 'sunrise/models/user'
  plugin.menu = 'main'
end   

# System settings
Sunrise::Plugin.register :settings do |plugin|
  plugin.model = false
  plugin.menu = 'main'
  plugin.klass_name = 'Sunrise::SystemSettings'
end 

# Static pages
Sunrise::Plugin.register :pages do |plugin|
  plugin.model = 'sunrise/models/page'
  plugin.menu = false
end 
 
# Assets
Sunrise::Plugin.register :assets do |plugin|
  plugin.model = 'sunrise/models/asset'
  plugin.menu = false
end

[:structures, :users, :settings, :pages, :assets].each { |plugin_name| Sunrise::Plugins.activate(plugin_name) }
