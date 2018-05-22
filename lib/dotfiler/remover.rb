module Dotfiler
  class Remover
    include Dotfiler::Import[fs: "file_system"]

    def call(path, only_symlinks: true)
      if only_symlinks && !path.symlink?
        raise(Error, "Cannot remove '#{path}' since it is not a symbolic link")
      end

      fs.remove(path.to_s)

      path
    end
  end
end
