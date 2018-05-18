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
end
