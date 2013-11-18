$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "has_filepicker_image/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "has_filepicker_image"
  s.version     = HasFilepickerImage::VERSION
  s.authors     = ["Pol"]
  s.email       = ["polmiro@gmail.com"]
  s.homepage    = ""
  s.summary     = "Easily add filepicker images to your models"
  s.description = "Easily add filepicker images to your models"
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rails", ">= 3.2"
  s.add_dependency "railties"

  s.add_development_dependency "appraisal"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-html-matchers"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "coveralls"
end
