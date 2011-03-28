Dir["#{File.dirname(__FILE__)}/core_ext/*.rb"].sort.each do |path|
  require "sunrise/core_ext/#{File.basename(path, '.rb')}"
end
