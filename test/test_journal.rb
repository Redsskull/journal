require 'minitest/autorun'
require_relative '../journal'

class TestJournal < Minitest::Test
  def test_journal_starts_empty
    journal = Journal.new('test journal')
    assert_equal 'test journal', journal.filename
    assert_equal 0, journal.entries.length
  end

  def test_add_entry
    journal = Journal.new('test journal')
    entry = Entry.new('Test body', 'Test title')
    journal.add_entry(entry)
    assert_equal 1, journal.entries.length
  end

  def test_save_and_load
    journal = Journal.new('test_save_load.txt')
    entry = Entry.new('Test Body', 'Test Title')
    journal.add_entry(entry)
    journal.save_to_file
    journal = Journal.new('test_save_load.txt')
    journal.load_from_file
    assert_equal 1, journal.entries.length
    assert_equal 'Test Body', entry.body
    assert_equal 'Test Title', entry.title
    # A lesson here, I am not mocking, I am creating a real file.
    # Must make sure to clean up after me, like free() in C!
    File.delete('data/test_save_load.txt') if File.exist?('data/test_save_load.txt')
  end

  def test_search_journal
    journal = Journal.new('test_search.txt')
    entry = Entry.new('Test Body', 'Test Title')
    journal.add_entry(entry)
    entry2 = Entry.new('Test Body2', 'Test Title2')
    journal.add_entry(entry2)
    entry3 = Entry.new('Test Body3', 'Test Title3')
    journal.add_entry(entry3)
    result = journal.search('Body2')
    assert_equal 1, result.length
    assert_equal 'Test Body2', result[0].body
    assert_equal entry2, result[0]
    results = journal.search('body')
    assert_equal 3, results.length
    resultsdown = journal.search('BODY') # testing downcase
    assert_equal 3, resultsdown.length
    resultsempty = journal.search('Daneel')
    assert_empty resultsempty
  end
end
