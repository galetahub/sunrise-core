module Sunrise
  module CarrierWave
    def self.obtain_class
      class_name = ENV['CLASS'] || ENV['class']
      raise "Must specify CLASS" unless class_name
      class_name.constantize
    end
  end
end

namespace :assets do
  desc "Refresh carrierwave assets by model"
  task :refresh do
    klass = Sunrise::CarrierWave.obtain_class
    
    klass.all.each do |item|
      item.recreate_versions!
    end
  end
end
