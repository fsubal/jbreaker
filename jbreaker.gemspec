# frozen_string_literal: true

require_relative 'lib/jbreaker/version'

Gem::Specification.new do |spec|
  spec.name        = 'jbreaker'
  spec.version     = Jbreaker::VERSION
  spec.authors     = ['fsubal']
  spec.email       = ['fsubal1102@gmail.com']
  spec.homepage    = 'https://github.com/fsubal/jbreaker'
  spec.summary     = 'Write jbuilder and JSON Schema in the same one file.'
  spec.description = 'Write jbuilder and JSON Schema in the same one file.'
  spec.license     = 'MIT'

  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/fsubal/jbreaker'
  spec.metadata['changelog_uri'] = 'https://github.com/fsubal/jbreaker/releases'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'jbuilder', '>= 2.0.0'
  spec.add_dependency 'rails', '>= 5.0.0' # same as jbuilder https://github.com/rails/jbuilder/blob/d2161bdc53675c578b8545a8835b0c79b675504c/jbuilder.gemspec#L12-L13

  spec.add_development_dependency 'rubocop', '1.24.0'
end
