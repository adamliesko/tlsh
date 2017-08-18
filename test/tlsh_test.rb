require 'test_helper'

class TlshTest < Minitest::Test
  INPUT_DATA = [11, 4, 0, 12, 4, 0, 8, 8, 4, 12, 0, 12, 8, 4, 4, 4, 8, 12, 0, 4, 8, 8, 12, 8, 4, 7, 20, 7, 4, 4, 4, 8, 4, 0, 4, 4, 8, 8, 0, 0, 0, 4, 4, 4, 8, 8, 12, 12, 8, 0, 4, 12, 0, 8, 4, 0, 4, 4, 10, 4, 4, 8, 12, 12, 8, 3, 0, 8, 8, 8, 4, 4, 16, 0, 0, 12, 12, 23, 4, 4, 4, 4, 15, 4, 12, 4, 12, 4, 16, 8, 12, 0, 4, 0, 20, 8, 8, 0, 4, 0, 4, 4, 8, 8, 24, 0, 0, 4, 16, 4, 8, 0, 4, 0, 4, 8, 0, 0, 14, 4, 4, 12, 12, 12, 8, 4, 4, 0, 8, 4, 4, 0, 20, 8, 4, 19, 4, 0, 4, 4, 4, 4, 0, 15, 4, 4, 0, 8, 8, 0, 4, 8, 0, 16, 0, 0, 12, 4, 4, 4, 11, 0, 8, 0, 12, 12, 8, 8, 4, 8, 3, 26, 8, 8, 4, 0, 0, 4, 8, 15, 12, 4, 4, 20, 7, 4, 4, 4, 0, 4, 8, 15, 4, 4, 0, 0, 4, 11, 4, 4, 8, 4, 4, 0, 0, 4, 8, 0, 0, 16, 16, 4, 8, 27, 4, 8, 11, 7, 0, 16, 8, 12, 0, 0, 8, 12, 8, 0, 4, 4, 0, 4, 4, 4, 0, 4, 12, 4, 8, 4, 16, 0, 4, 4, 0, 15, 0, 4, 8, 4, 8, 0, 12, 0, 12, 0].freeze
  FIXTURES_PATH = File.expand_path('../test/fixtures/', File.dirname(__FILE__))

  def test_version_number
    refute_nil ::Tlsh::VERSION
  end

  def test_hash_files
    t1 = Tlsh.hash_file(File.join(FIXTURES_PATH, 'test_file_1')).string.to_s
    assert_equal('8ed0222fc3080233a02b03b3330fc3a82f8308c2fa0a080b8bae2cca0c3', t1)

    t2 = Tlsh.hash_file(File.join(FIXTURES_PATH, 'test_file_2')).string.to_s
    assert_equal('b231c738fac0333c8ffbe3ff32fcf3bbfb3faa3ef3bf3c880cfc83ebfabf3ccb3fbfc', t2)

    t3 = Tlsh.hash_file(File.join(FIXTURES_PATH, 'test_file_3')).string.to_s
    assert_equal('ea31a48baaca23ba2eaa83aafa8fabebbfafcabca338aa2aa8eaabb8aabcaea3babfa', t3)
  end

  def test_diff_files
    file1 = File.join(FIXTURES_PATH, 'test_file_1')
    file_lena8 = File.join(FIXTURES_PATH, 'test_file_8_lena.png')

    assert_equal(500, Tlsh.diff_files(file1, File.join(FIXTURES_PATH, 'test_file_2')))
    assert_equal(1057, Tlsh.diff_files(file1, file_lena8))
    assert_equal(917, Tlsh.diff_files(File.join(FIXTURES_PATH, 'test_file_3'), file_lena8))
    assert_equal(593, Tlsh.diff_files(File.join(FIXTURES_PATH, 'test_file_7_lena.jpg'), file_lena8))
  end

  def test_diff_identical_files
    file1 = File.join(FIXTURES_PATH, 'test_file_1')
    assert_equal(0, Tlsh.diff_files(file1, file1))
  end

  def test_diff_files_raises_error
    assert_raises Errno::ENOENT do
      Tlsh.diff_files('not_found', '')
    end
  end

  def test_hash_bytes
    tlsh = Tlsh.hash_bytes(INPUT_DATA)
    assert_equal('d4d021b2eaf3eabaf0b8cfbbafc3eeb8aeb23b323b3ee28a238b8aa8ebbbc3ae2aba', tlsh.string)
    assert_equal([212, 208, 33, 178, 234, 243, 234, 186, 240, 184, 207, 187, 175, 195, 238, 11, 138, 14, 178, 59, 50, 59, 62, 226, 138, 35, 139, 138, 168, 235, 187, 195, 174, 42, 186], tlsh.binary)
  end
end
