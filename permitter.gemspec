$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "permitter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "permitter"
  s.version     = Permitter::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Permitter."
  s.description = "TODO: Description of Permitter."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "sqlite3", "~> 1.3.8"
  s.add_development_dependency "rspec", "~> 2.14.1"
end
