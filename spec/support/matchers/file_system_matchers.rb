require "rspec/expectations"

RSpec::Matchers.define :be_a_file do
  match do |path|
    File.exists?(path)
  end
end

RSpec::Matchers.define :be_a_directory do
  match do |path|
    Dir.exists?(path)
  end
end

RSpec::Matchers.define :be_a_symlink do
  match do |path|
    File.symlink?(File.expand_path(path))
  end
end

RSpec::Matchers.define :be_a_symlink_of do |expected|
  match do |path|
    File.symlink?(File.expand_path(path)) && File.realpath(path).eql?(expected)
  end
end

RSpec::Matchers.define :exist do |expected|
  match do |path|
    File.exists?(File.expand_path(path))
  end
end
