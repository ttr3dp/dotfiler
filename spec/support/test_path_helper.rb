module TestPathHelper
  def test_path(path = nil)
    pathname = Pathname.new(TMP_DIR)

    pathname.join(path).to_s
  end
end
