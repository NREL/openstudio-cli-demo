# call this script with `openstudio driver.rb`
# this code will eventually be in the OpenStudio CLI 

require 'openstudio'
require 'fileutils'

if OpenStudio::VersionString.new(OpenStudio::openStudioVersion()) < OpenStudio::VersionString.new('2.8.1')
  puts 'Example requires OpenStudio 2.8.1 or higher'
end

require 'openstudio/extension'
require 'bundler/ruby_version'
require 'bundler/uri_credentials_filter'
require 'bundler/source'
require 'bundler/definition'

root_dir = File.dirname(__FILE__)
in_osw = File.join(root_dir, 'in.osw')
run_dir = File.join(root_dir, 'run/')
bundle_dir = File.join(root_dir, '.bundle/')
gemfile_lock = File.join(root_dir, 'Gemfile.lock')

FileUtils.rm_rf(bundle_dir) if File.exist?(bundle_dir)
FileUtils.rm_f(gemfile_lock) if File.exist?(gemfile_lock)

# figure out where to do this
idf_file = File.join(run_dir, 'in.idf')
FileUtils.rm_rf(idf_file) if File.exist?(idf_file)

bundle_without = []
runner = OpenStudio::Extension::Runner.new(File.dirname(__FILE__), bundle_without)
runner.run_osw(in_osw, run_dir)