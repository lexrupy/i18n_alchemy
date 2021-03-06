require "test_helper"

class ProxyTest < MiniTest::Unit::TestCase
  def setup
    @product   = Product.new
    @localized = @product.localized

    I18n.locale = :pt
  end

  def teardown
    I18n.locale = :en
  end

  def test_delegates_orm_methods_to_target_object
    assert @product.new_record?
    assert @localized.save!(:name => "foo", :price => 1.99)
    assert !@product.new_record?
  end

  def test_delegates_method_with_block_to_target_object
    @localized.method_with_block do |attr|
      assert_equal "called!", attr
    end
  end

  def test_respond_to
    assert_respond_to @localized, :price
    assert_respond_to @localized, :price=
    assert_respond_to @localized, :name
    assert_respond_to @localized, :save
  end

  def test_does_not_localize_primary_key
    @product.id = 1
    assert_equal 1, @localized.id
  end

  def test_does_not_localize_foreign_keys
    @product.supplier_id = 1
    assert_equal 1, @localized.supplier_id
  end

  # Numeric
  def test_parses_numeric_attribute_input
    @localized.price = "1,99"
    assert_equal 1.99, @product.price
  end

  def test_localizes_numeric_attribute_output
    @product.price = 1.88
    assert_equal "1,88", @localized.price
  end

  def test_parsers_integer_attribute_input
    @localized.quantity = "1,0"
    assert_equal 1, @product.quantity
  end

  def test_localized_integer_attribute_output
    @product.quantity = 1.0
    assert_equal "1", @localized.quantity
  end

  def test_does_not_localize_other_attribute_input
    @localized.name = "foo"
    assert_equal "foo", @product.name
  end

  def test_does_not_localize_other_attribute_output
    @product.name = "foo"
    assert_equal "foo", @localized.name
  end

  # Date
  def test_parses_date_attribute_input
    @localized.released_at = "28/02/2011"
    assert_equal Date.new(2011, 2, 28), @product.released_at
  end

  def test_localizes_date_attribute_output
    @product.released_at = Date.new(2011, 2, 28)
    assert_equal "28/02/2011", @localized.released_at
  end

  # DateTime
  def test_parses_datetime_attribute_input
    @localized.updated_at = "28/02/2011 13:25:30"
    assert_equal Time.mktime(2011, 2, 28, 13, 25, 30), @product.updated_at
  end

  def test_localizes_datetime_attribute_output
    @product.updated_at = Time.mktime(2011, 2, 28, 13, 25, 30)
    assert_equal "28/02/2011 13:25:30", @localized.updated_at
  end

  # Timestamp
  def test_parses_datetime_attribute_input
    @localized.last_sale_at = "28/02/2011 13:25:30"
    assert_equal Time.mktime(2011, 2, 28, 13, 25, 30), @product.last_sale_at
  end

  def test_localizes_datetime_attribute_output
    @product.last_sale_at = Time.mktime(2011, 2, 28, 13, 25, 30)
    assert_equal "28/02/2011 13:25:30", @localized.last_sale_at
  end

  # Attributes
  def test_proxy_only_the_given_attributes
    @localized = @product.localized(:released_at)

    @localized.price = "1,99"
    assert_equal 1.00, @product.price
    assert_equal 1.00, @localized.price

    @localized.released_at = "28/02/2011"
    assert_equal Date.new(2011, 2, 28), @product.released_at
    assert_equal "28/02/2011", @localized.released_at
  end
end
