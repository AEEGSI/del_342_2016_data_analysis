require 'slop'
require "bundler/setup"
require "del_342_2016_data_analysis"

opts = Slop.parse do |o|
  o.banner = "usage: bin/create_folders.rb [options] path"
  o.on '--help' do
    puts o
    exit
  end
end

if path = opts.arguments.shift
  Del3422016DataAnalysis::Folders.create_folders path
else
  puts "You have to pass a valid path"
end
