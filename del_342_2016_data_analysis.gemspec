# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'del_342_2016_data_analysis/version'

Gem::Specification.new do |spec|
  spec.name          = "del_342_2016_data_analysis"
  spec.version       = Del3422016DataAnalysis::VERSION
  spec.authors       = ["Iwan Buetti"]
  spec.email         = ["iwan.buetti@gmail.com"]

  spec.summary       = "Del. 342/2016 Data Analysis"
  spec.description   = "Scripts used to read and analyse data provided by electricity market operator in order to discover any abuse."
  spec.homepage      = "https://github.com/AEEGSI/del_342_2016_data_analysis"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_dependency "slop", "~> 4.6.1"
end
