require 'spec_helper'
require 'fileutils'

describe Sunrise::Generators::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../tmp", __FILE__)
#  arguments %w(something)

  before(:all) do
    prepare_destination
    
    dir = File.expand_path("../../", __FILE__)
    FileUtils.mkdir_p(File.join(dir, "tmp/config"))
    FileUtils.copy_file(File.join(dir, "dummy/config/routes.rb"), File.join(dir, "tmp/config", "routes.rb"))
    FileUtils.copy_file(File.join(dir, "dummy/config/application.rb"), File.join(dir, "tmp/config", "application.rb"))
    
    run_generator
  end
  
  it "should copy_images" do
    assert_directory "public/images/manage"
    assert_file "public/images/alert.png"
  end
  
  it "should copy_javascripts" do
    assert_directory "public/javascripts"
    assert_file "public/javascripts/manage.js"
  end
  
  it "should copy_stylesheets" do
    assert_directory "public/stylesheets/manage"
    assert_file "public/stylesheets/alert.css"
  end
  
  it "should copy_views" do
    assert_directory "app/views"
  end
  
  it "should copy_configurations" do
    ["db/seeds.rb", "config/initializers/sunrise.rb", "config/application.yml.sample", "config/database.yml.sample",
     "config/logrotate-config.sample", "config/nginx-config-passenger.sample"].each do |file|
      assert_file file
    end
  end
  
  it "should copy_helpers" do
    assert_directory "app/helpers/manage"
  end
  
  it "should copy_models" do
    assert_directory "app/models/defaults"
  end

  it "should copy_specs" do
    assert_directory "spec"
    assert_file "spec/spec_helper.rb"
    assert_file ".rspec"
  end

  it "should create migration" do
    [:users, :roles, :structures, :pages, :assets, :headers].each do |item|
      assert_migration "db/migrate/sunrise_create_#{item}.rb" do |migration|
        assert_class_method :up, migration do |up|
          assert_match /create_table/, up
        end
      end
    end
  end
end
