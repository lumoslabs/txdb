$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'txdb/version'

Gem::Specification.new do |s|
  s.name     = 'txdb'
  s.version  = ::Txdb::VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = 'https://github.com/lumoslabs/txdb'

  s.description = s.summary = 'An automation tool for translating database content with Transifex.'

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency 'activesupport', '~> 4.0'
  s.add_dependency 'sequel', '~> 4.0'
  s.add_dependency 'txgh', '~> 2.0'

  s.require_path = 'lib'
  s.files = Dir['{lib,spec}/**/*', 'README.md', 'txdb.gemspec', 'LICENSE']
end
