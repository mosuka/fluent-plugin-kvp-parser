# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-kvp-parser"
  spec.version       = "0.0.6"
  spec.description   = 'Fluentd parser plugin to parse key value pairs'
  spec.authors       = ["mosuka"]
  spec.email         = ["minoru.osuka@gmail.com"]
  spec.summary       = %q{Fluentd parser plugin to parse key value pairs}
  spec.homepage      = "https://github.com/mosuka/fluent-plugin-kvp-parser"
  spec.license       = "Apache License, Version 2.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", '~> 1.15.0'
  spec.add_development_dependency "rake", '~> 11.1.2'
  spec.add_runtime_dependency "fluentd", ['>= 0.10.0', '< 0.14.0']
end
