require 'minitest/autorun'
require_relative '../entry'

class TestEntry < Minitest::Test
  def test_entry_with_specific_date
    entry = Entry.new('test body', 'test title', '26-02-12')
    assert_equal 'test body', entry.body
    assert_equal '26-02-12', entry.date
    assert_equal 'test title', entry.title
  end

  def test_entry_without_specific_date
    entry = Entry.new('test body', 'test title')
    assert_equal 'test body', entry.body
    assert_equal Time.now.strftime('%y-%m-%d'), entry.date
    assert_equal 'test title', entry.title
  end

  def test_entry_without_empty_title
    entry = Entry.new('test body')
    assert_equal 'test body', entry.body
    assert_equal Time.now.strftime('%y-%m-%d'), entry.date
    assert_equal '', entry.title
  end
end
