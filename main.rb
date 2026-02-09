require 'bundler/setup'
require 'artii'
require 'colorize'
require 'tty-prompt'
require_relative 'journal'

$rerun = false

def show_menu
  slant_font = Artii::Base.new font: 'slant'
  doom_font = Artii::Base.new font: 'doom'
  prompt = TTY::Prompt.new(active_color: :green)
  journal = Journal.new('my_journal.txt')
  journal.load_from_file

  loop do
    puts slant_font.asciify('ALIEN JOURNAL').light_green unless $rerun
    choice = prompt.select('Please select action',
                           ['Write new entry', 'View all entries', 'Search entries', 'Edit entry', 'Delete entry',
                            'Quit']).downcase
    case choice
    when 'write new entry'
      puts "Please select a title for entry if you'd like one(Press Enter to skip): ".light_green
      title = gets.chomp
      puts 'What is on your mind today? '.light_green
      body = gets.chomp
      entry = Entry.new(body, title)
      journal.add_entry(entry)
      puts 'Entry saved, survivor'.green
      $rerun = true
    when 'view all entries'
      journal.display_all
      $rerun = true
    when 'search entries'
      print 'Search for: '.light_green
      query = gets.chomp
      search_query(journal, query)
    when 'edit entry'
      print 'Search for query to edit: '.light_green
      query = gets.chomp
      results = search_query(journal, query)

      if results.any?
        print "which entry to edit? (1-#{results.length}): ".light_green
        choice = gets.chomp.to_i - 1
        # need to delete at the entry index and add the edit to the same index
        journal.edit_entry(results[choice])
        puts 'Here is your edited entry: '.light_green
        results[choice].display
      end
    when 'delete entry'
      print 'Search for entry to delete: '.light_green
      query = gets.chomp
      results = search_query(journal, query)

      if results.any?
        print "Which entry to delete? (1-#{results.length}): ".light_green
        choice = gets.chomp.to_i - 1
        journal.delete_entry(results[choice])
        puts 'Deleted!'.light_green.bold
      end
    when 'quit'
      puts doom_font.asciify('YOU SURVIVED ONE MORE DAY').light_green
      exit(0)
    end
  end
end

def search_query(journal, query)
  results = journal.search(query)

  if results.empty?
    puts 'No matches found.'.red
  else
    # Display with numbers
    results.each_with_index do |entry, index|
      puts "\n--- Entry #{index + 1} ---".light_green
      entry.display
    end
  end
  results
end

show_menu
