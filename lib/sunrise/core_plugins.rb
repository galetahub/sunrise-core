# Structure tree
Sunrise::Plugin.register :structures do |plugin|
  plugin.model = 'sunrise/models/structure'
  plugin.menu = 'main'
  plugin.version = Sunrise::VERSION.dup
end

# Users
Sunrise::Plugin.register :users do |plugin|
  plugin.model = 'sunrise/models/user'
  plugin.menu = 'main'
  plugin.version = Sunrise::VERSION.dup
end   

# System settings
Sunrise::Plugin.register :settings do |plugin|
  plugin.model = false
  plugin.menu = 'main'
  plugin.klass = Sunrise::SystemSettings
  plugin.version = Sunrise::VERSION.dup
end 

# Static pages
Sunrise::Plugin.register :pages do |plugin|
  plugin.model = 'sunrise/models/page'
  plugin.menu = false
  plugin.version = Sunrise::VERSION.dup
end 
 
# Assets
Sunrise::Plugin.register :assets do |plugin|
  plugin.model = 'sunrise/models/asset'
  plugin.menu = false
  plugin.version = Sunrise::VERSION.dup
end

[:structures, :users, :settings, :pages, :assets].each { |plugin_name| Sunrise::Plugins.activate(plugin_name) }
