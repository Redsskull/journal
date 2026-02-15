# require 'bundler/setup'
require 'minitest/autorun'
require_relative '../journal_manager'

class TestManager < Minitest::Test
  def setup
    # Runs before each test
    @test_files = []
  end

  def teardown
    @test_files.each do |file|
      File.delete("data/#{file}") if File.exist?("data/#{file}")
    end

    begin
      Dir.delete('data') if File.directory?('data')
    rescue Errno::ENOTEMPTY
      # Directory not empty - that's fine
    rescue Errno::ENOENT
      # Directory doesn't exist - that's fine too
    end
  end

  def track_file(filename)
    # populates @test_files for cleanup
    @test_files << filename
  end

  def test_manager_swap
    journal1 = 'work_journal'
    journal2 = 'private journal'
    track_file(journal1)
    track_file(journal2)

    manager = JournalManager.new
    # User opens new Journal
    journal = manager.load_journal(journal1)
    journal.add_entry(Entry.new('finished project', 'work'))
    assert_equal journal1, journal.filename
    # swap to file 2
    journal = manager.swap_journal(journal2)
    journal.add_entry(Entry.new('Personal thoughts', 'Personal'))
    assert_equal journal2, journal.filename
    refute_equal journal.filename, journal1
    # User swaps back
    journal = manager.swap_journal(journal1)
    assert_equal journal1, journal.filename
    assert_equal 'work', journal.entries.first.title
  end
end
