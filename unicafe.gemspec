# -*- encoding: utf-8 -*-
require File.expand_path('../lib/unicafe/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sami Saada"]
  gem.email         = ["sami.saada@gmail.com"]
  gem.description   = %q{Gem for fetching Unicafe lunch data}
  gem.summary       = %q{Fetches and parses Unicafe rss feeds, might even find
                         lunch data.}
  gem.homepage      = "https://github.com/samitheberber/unicafe"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "unicafe"
  gem.require_paths = ["lib"]
  gem.version       = Unicafe::VERSION

  gem.add_dependency 'feedzirra'
  gem.add_dependency 'geocoder'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'fakeweb'
end
