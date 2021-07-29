module FileSystemHelper
  module_function

  def create_file(path, content = nil)
    file_path = test_path(path)
    if content == nil
      system("touch #{file_path}")
    else
      file = File.new(file_path, "w+")
      file.write(content)
      file.close
    end
    file_path
  end

  def create_dir(path)
    dir_path = test_path(path)
    system("mkdir -p #{dir_path}")
    dir_path
  end

  def create_symlink(source, destination)
    source_path = test_path(source)
    symlink_path = test_path(destination)
    system("ln -s #{source_path} #{symlink_path}")
    symlink_path
  end

  def file(source)
    path = test_path(source)
    File.open(path, "r")
  end
end
