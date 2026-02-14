require 'minitest/autorun'
require_relative '../journal'

class TestIntegration < Minitest::Test
  def setup
    # Runs before each test
    @test_files = []
  end

  def teardown
    # Runs after each test - cleanup the files I made if I did
    @test_files.each do |file|
      File.delete("data/#{file}") if File.exist?("data/#{file}")
    end
  end

  def track_file(filename)
    # populates @test_files for cleanup
    @test_files << filename
  end

  def test_swap_journals
    # I usually don't comment my tests, but since this is a firs time doing this, I'll comment as I go.
    # Might be good practice from now on
    file1 = 'work journal.txt'
    file2 = 'perosnal journal.txt'
    track_file(file1)
    track_file(file2)

    # User creates first journal (work journal)
    work_journal = Journal.new(file1)
    work_journal.add_entry(Entry.new('Finished project', 'Work'))
    work_journal.save_to_file

    # User creates second journal (personal journal)
    personal_journal = Journal.new(file2)
    personal_journal.add_entry(Entry.new('Went to beach', 'Personal'))
    personal_journal.save_to_file

    # User is currently using work journal
    current_journal = Journal.new(file1)
    current_journal.load_from_file
    assert_equal 'Work', current_journal.entries.first.title

    # User swaps to personal journal (simulating the menu choice)
    current_journal = Journal.new(file2)
    current_journal.load_from_file
    assert_equal 'Personal', current_journal.entries.first.title

    # Verify it's actually different
    refute_equal 'Work', current_journal.entries.first.title
  end
end
