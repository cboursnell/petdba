require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'minitest/autorun'
begin; require 'turn/autorun'; rescue LoadError; end
require 'shoulda/context'
require 'assembler'
require 'assembler/assembler.so'

Turn.config.format = :pretty
Turn.config.trace = 5
