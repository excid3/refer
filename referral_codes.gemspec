require_relative "lib/referral_codes/version"

Gem::Specification.new do |spec|
  spec.name        = "referral_codes"
  spec.version     = ReferralCodes::VERSION
  spec.authors     = [ "Chris Oliver" ]
  spec.email       = [ "excid3@gmail.com" ]
  spec.homepage    = "https://github.com/excid3/referral_codes"
  spec.summary     = "Referral codes for Ruby on Rails applications"
  spec.description = "Referral codes for Ruby on Rails applications"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/excid3/referral_codes"
  spec.metadata["changelog_uri"] = "https://github.com/excid3/referral_codes/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 6.1.0"
end
