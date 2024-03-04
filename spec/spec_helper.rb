# frozen_string_literal: true

class ActiveImaginationTest
  DEFAULT_ADAPTER = "sqlite"
  VALID_ADAPTERS = %w[mysql2 postgresql sqlite].freeze
  ORIG_EXTENSION = "orig"
  DATABASE_YML_FILENAME = "spec/internal/config/database.yml"

  def self.find_adapter
    ENV["RSPEC_ADAPTER"].presence || ::ActiveImaginationTest::DEFAULT_ADAPTER
  end

  def self.assert_valid_adapter!(adapter)
    raise "RSPEC_ADAPTER '#{adapter}' not valid" unless ::ActiveImaginationTest::VALID_ADAPTERS.include? adapter
  end

  def self.cp_adapter_file(adapter)
    FileUtils.cp(
      "#{::ActiveImaginationTest::DATABASE_YML_FILENAME}.#{adapter}",
      ::ActiveImaginationTest::DATABASE_YML_FILENAME
    )
  end

  def self.restore_adapter_file
    cp_adapter_file(::ActiveImaginationTest::ORIG_EXTENSION)
  end
end

require "bundler"

Bundler.require :default, :development

if ActiveRecord.gem_version >= Gem::Version.new("6.1") && ActiveRecord.gem_version < Gem::Version.new("7.1")
  # This causes all Rails deprecation warnings to raise.
  # We would like to use this feature all the time, but it was only introduced in 6.1,
  # and combustion <= 1.3.7 throws a deprecation in Rails 7.1. Test whether
  # combustion 1.4.0 fixed it: https://github.com/pat/combustion/pull/131
  ActiveSupport::Deprecation.disallowed_warnings = :all
end

# Set the adapter for this run by copying the appropriate file into place.
adapter = ActiveImaginationTest.find_adapter
ActiveImaginationTest.assert_valid_adapter!(adapter)
ActiveImaginationTest.cp_adapter_file(adapter)
puts "Running RSpec for #{adapter} on ActiveRecord #{ActiveRecord.version} on ruby #{RUBY_VERSION}"

Combustion.initialize! :active_record

RSpec.configure do |config|
  config.warnings = true
  config.raise_errors_for_deprecations!

  config.after(:suite) do
    ActiveImaginationTest.restore_adapter_file
  end
end
