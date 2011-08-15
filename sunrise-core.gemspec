# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sunrise/version"

Gem::Specification.new do |s|
  s.name = "sunrise-core"
  s.version = Sunrise::VERSION.dup
  s.platform = Gem::Platform::RUBY 
  s.summary = "Rails CMS"
  s.description = "Sunrise is a Aimbulance CMS"
  s.authors = ["Igor Galeta", "Pavlo Galeta"]
  s.email = "galeta.igor@gmail.com"
  s.rubyforge_project = "sunrise-core"
  s.homepage = "https://github.com/galetahub/sunrise-core"
  
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.test_files = Dir["{spec}/**/*"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency(%q<rails>, ["~> 3.0.9"])
  s.add_runtime_dependency(%q<nokogiri>, ["~> 1.5.0"])
  s.add_runtime_dependency(%q<inherited_resources>, ["~> 1.2.2"])
  s.add_runtime_dependency(%q<paperclip>, ["~> 2.3.16"])
  s.add_runtime_dependency(%q<mime-types>, ["~> 1.16"])
  s.add_runtime_dependency(%q<kaminari>, ["~> 0.12.4"])
  s.add_runtime_dependency(%q<cancan>, ["~> 1.6.5"])
  s.add_runtime_dependency(%q<cancan_namespace>, ["~> 0.1.3"])
  s.add_runtime_dependency(%q<devise>, ["~> 1.4.2"])
  s.add_runtime_dependency(%q<simple_form>, ["~> 1.4.2"])
  s.add_runtime_dependency(%q<awesome_nested_set>, ["~> 2.0.1"])
  s.add_runtime_dependency(%q<fastercsv>, ["~> 1.5.4"])
  s.add_runtime_dependency(%q<ckeditor>, [">= 0"])
  s.add_runtime_dependency(%q<galetahub-enum_field>, ["~> 0.1.4"])
  s.add_runtime_dependency(%q<galetahub-salty_slugs>, ["~> 1.0.0"])
  s.add_runtime_dependency(%q<sunrise-file-upload>, ["~> 0.1.2"])
  
  s.add_development_dependency(%q<rspec-rails>, ["= 2.6.1"])
  s.add_development_dependency(%q<mysql2>, ["~> 0.2.10"])
  s.add_development_dependency(%q<capybara>, ["~> 1.0.0"])
  s.add_development_dependency(%q<database_cleaner>, [">= 0"])
  s.add_development_dependency(%q<factory_girl>, [">= 0"])
  s.add_development_dependency(%q<fuubar>, [">= 0"])
end
