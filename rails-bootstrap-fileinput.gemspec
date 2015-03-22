$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bootstrap_fileinput/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails-bootstrap-fileinput"
  s.version     = BootstrapFileinput::VERSION
  s.authors     = ["Florent Ruard-Dumaine"]
  s.email       = ["atalargo@gmail.com"]
  s.homepage    = 'http://github.com/atalargo/rails-boostrap-fileinput'
  s.summary     = 'TODO: Summary of Rails Bootstrap Fileinput.'
  s.description = "TODO: Description of Rails Bootstrap Fileinput."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency 'jquery-rails'
  s.add_dependency 'bootstrap-sass', '>= 3.2.0'

  s.add_development_dependency "sqlite3"
end

