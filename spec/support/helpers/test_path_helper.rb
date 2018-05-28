module TestPathHelper
  def test_path(path = nil)
    pathname = Pathname.new(TMP_DIR)

    pathname.join(path).to_s
  end

  def home_path(path = nil)
    pathname = Pathname.new("~")

    return pathname.to_s unless path

    pathname.join(path).to_s
  end

  def dotfiles_path(path = nil)
    pathname = Pathname.new(test_path("dotfiles"))

    return pathname.to_s unless path

    pathname.join(path).to_s
  end

  def links_path(path = nil)
    pathname = Pathname.new(dotfiles_path(".links"))

    return pathname.to_s unless path

    pathname.join(path).to_s
  end

  def to_test_path(string)
    Dotfiler.resolve["to_path"].call(test_path(string))
  end
end
