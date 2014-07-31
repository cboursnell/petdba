require 'rake/testtask'
require 'rake/extensiontask'

Rake::ExtensionTask.new('assembler') do |ext|
  ext.lib_dir = "lib/assembler"
end

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test
