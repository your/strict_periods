# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "strict_periods"
  spec.version       = "0.0.1"
  spec.authors       = ["your"]
  spec.email         = ["g.lobraico@gmail.com"]

  spec.summary       = %q{week picker utility}
  spec.description   = %q{Get an array of weeks after/before and anchor date}
  spec.homepage      = "http://github.com/your/strict_periods"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files = Dir['lib/**/*.rb']
  spec.require_path = 'lib'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
