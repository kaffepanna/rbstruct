# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "rbstruct"
  spec.version       = `git describe --abbrev=0 --tags`
  spec.authors       = ["Patrik Pettersson"]
  spec.email         = ["pettersson.pa@gmail.com"]

  spec.summary       = %q{Create C like structs in ruby}
  spec.description   = %q{C like structs for ruby allowing read/write from binary files"}
  spec.homepage      = "https://github.com/kaffepanna/rbstruct"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
