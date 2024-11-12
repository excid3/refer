require_relative "lib/refer/version"

Gem::Specification.new do |spec|
  spec.name        = "refer"
  spec.version     = Refer::VERSION
  spec.authors     = [ "Chris Oliver" ]
  spec.email       = [ "excid3@gmail.com" ]
  spec.homepage    = "https://github.com/excid3/refer"
  spec.summary     = "Referral codes & affiliate links for Ruby on Rails apps"
  spec.description = "Referral codes & affiliate links for Ruby on Rails apps"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + "/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.0"
end
