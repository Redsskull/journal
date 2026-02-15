require 'bundler/setup'
# A small script to run all the tests

Dir.glob('test/test_*.rb').each { |file| require_relative file.sub('test/', '') }
