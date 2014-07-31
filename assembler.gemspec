Gem::Specification.new do |gem|
  gem.name          = 'assembler'
  gem.authors       = [ "Chris Boursnell" ]
  gem.email         = "cmb211@cam.ac.uk"
  gem.licenses      = ["MIT"]
  gem.summary       = "experimental de bruijn graph assembler"
  gem.description   = "experimental de bruijn graph that uses paired information"
  gem.version       = '0.0.1'

  gem.files = `git ls-files`.split("\n")
  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = %w( lib ext )
  gem.extensions  = ["ext/assembler/extconf.rb"]

  gem.add_dependency 'trollop', '~> 2.0'
  gem.add_dependency 'which', '~> 0.0', '>= 0.0.2'

  gem.add_development_dependency 'rake', '~> 10.3', '>= 10.3.2'
  gem.add_development_dependency 'rake-compiler', '~> 0.9', '>= 0.9.2'
  gem.add_development_dependency 'turn', '~> 0.9', '>= 0.9.7'
  gem.add_development_dependency 'minitest', '~> 4', '>= 4.7.5'
  gem.add_development_dependency 'simplecov', '~> 0.8', '>= 0.8.2'
  gem.add_development_dependency 'shoulda-context', '~> 1.2', '>= 1.2.1'
  gem.add_development_dependency 'coveralls', '~> 0.7'
end
