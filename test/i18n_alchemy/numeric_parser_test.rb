require "test_helper"

class NumericParserTest < MiniTest::Unit::TestCase
  def setup
    @parser = I18n::Alchemy::NumericParser
  end

  def test_does_not_convert_non_string_objects
    assert_equal 1.2, @parser.parse(1.2)
  end

  def test_parses_valid_string_numbers
    assert_equal "1.2", @parser.parse("1.2")
  end

  def test_parses_string_numbers_with_delimiters
    assert_equal "1_001.2", @parser.parse("1,001.2")
    assert_equal "1_000_001.2", @parser.parse("1,000_001.2")
  end

  def test_integers
    assert_equal "999", @parser.parse("999")
  end

  def test_parses_string_numbers_based_on_current_i18n_locale
    I18n.with_locale :pt do
      assert_equal "1.2", @parser.parse("1,2")
    end
  end

  def test_parses_string_numbers_with_delimiters_based_on_current_i18n_locale
    I18n.with_locale :pt do
      assert_equal "1_001.2", @parser.parse("1.001,2")
    end
  end

  def test_does_not_localize_string_values
    assert_equal "1.2", @parser.localize("1.2")
  end

  def test_localize_numeric_values
    assert_equal "1.2", @parser.localize(1.2)
  end

  def test_localize_numeric_values_with_delimiters
    assert_equal "1001.2", @parser.localize(1001.2)
    assert_equal "1000001.2", @parser.localize(1_000_001.2)
  end

  def test_localize_numbers_based_on_current_i18n_locale
    I18n.with_locale :pt do
      assert_equal "1,2", @parser.localize(1.2)
    end
  end

  def test_localize_numbers_with_delimiters_based_on_current_i18n_locale
    I18n.with_locale :pt do
      assert_equal "1001,2", @parser.localize(1_001.2)
    end
  end
end
