$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "permitter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "permitter"
  s.version     = Permitter::VERSION
  s.author      = "Matthew Erhard"
  s.email       = "merhard@gmail.com"
  s.homepage    = "http://github.com/merhard/permitter"
  s.summary     = "Simple Rails 4 authorization solution."
  s.description = "Simple Rails 4 authorization solution for developer to permit user allowances. Developer whitelists controller actions and resources per user type."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "sqlite3", "~> 1.3.8"
  s.add_development_dependency "rspec-rails", "~> 2.14.0"
  s.add_development_dependency "factory_girl_rails", "~> 4.3.0"
  s.add_development_dependency "pry", "~> 0.9.12.4"
end
