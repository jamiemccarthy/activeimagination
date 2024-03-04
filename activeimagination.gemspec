# frozen_string_literal: true

require_relative "lib/active_imagination/version"

Gem::Specification.new do |s|
  s.name = "activeimagination"
  s.version = ActiveImagination::VERSION
  s.license = "MIT"
  s.summary = "Structured-data content-creation aided by LLM"
  s.description = <<~EODESC
    ActiveImagination facilitates using LLMs to generate ActiveRecord content
  EODESC
  s.author = "James McCarthy"
  s.email = "jamie@mccarthy.vg"
  s.homepage = "https://github.com/jamiemccarthy/activeimagination"
  s.metadata = {
    "changelog_uri" => "https://github.com/jamiemccarthy/activeimagination/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }
  s.files = Dir["lib/**/*"] +
    Dir["spec/**"] + [
      "CHANGELOG.md",
      "CODE_OF_CONDUCT.md",
      "Gemfile",
      "LICENSE",
      "README.md"
    ]

  s.required_ruby_version = ">= 2.7"

  s.add_dependency "activerecord", ">= 5.2", "< 8.0"
  s.add_dependency "railties", ">= 5.2", "< 8.0"
end
