require_relative 'journal'
require 'tty-prompt'
# a file to manage which journal is opened
class JournalManager
  def initialize
    @current_journal = nil
  end

  def load_journal(filename)
    @current_journal = Journal.new(filename)
    @current_journal.load_from_file
    @current_journal
  end

  def swap_journal(filename = nil)
    @current_journal.save_to_file if @current_journal

    # If no filename provided, prompt user
    if filename.nil?
      prompt = TTY::Prompt.new(active_color: :green)
      journal_files = Dir.glob('data/*txt').map { |path| File.basename(path) }

      if journal_files.empty?
        puts 'No saved journals found. starting default My Journal'.yellow
        filename = 'My Journal.txt'
      else
        filename = prompt.select('Select your journal', journal_files)
      end
    end

    load_journal(filename)
  end

  attr_reader :current_journal
end
