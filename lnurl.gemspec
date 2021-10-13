require_relative 'lib/lnurl'

Gem::Specification.new do |spec|
  spec.name          = "lnurl"
  spec.version       = Lnurl::VERSION
  spec.authors       = ["Michael Bumann"]
  spec.email         = ["hello@michaelbumann.com"]

  spec.summary       = %q{LNURL implementation for ruby}
  spec.description   = %q{A collection of tools to work with LNURLs - the protocol for interaction between Lightning wallets and third-party services.}
  spec.homepage      = "https://github.com/bumi/lnurl-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bumi/lnurl-ruby"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.metadata['funding'] = 'lightning:02ad33d99d0bb3bf3bb8ec8e089cbefa8fd7de23a13cfa59aec9af9730816be76f'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'bech32', '~> 1.2.0'
end
