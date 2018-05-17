module Dotfiler
  class Remover
    include Dotfiler::Import[fs: "file_system"]

    def call(path, only_symlinks: true)
      if only_symlinks
        raise "Cannot remove '#{path}' since it is not a symbolic link" unless fs.symlink?(path) 
      end

      fs.remove(path)

      path
    end
  end
end
