require 'bundler/setup'
require 'colorize'
require_relative 'journal'

$rerun = false

def show_menu
  puts "\n=== Welcome to your journal ===".light_green.bold unless $rerun
  puts 'Please select action.'.light_green.bold
  puts '1. Write new entry'.light_green
  puts '2. View all entries'.light_green
  puts '3. Search entries'.light_green
  puts '4. Edit entry'.light_green
  puts '5. Delete entry'.light_green
  puts '6. Quit'.light_green
  print 'Choose an option: '.green
end

def run
  journal = Journal.new('my_journal.txt')
  journal.load_from_file

  loop do
    show_menu
    choice = gets.chomp

    case choice
    when '1'
      # adding an entry to journals @entries
      puts "Please select a title for entry if you'd like one(Press Enter to skip): ".light_green
      title = gets.chomp
      puts 'What is on your mind today? '.light_green
      body = gets.chomp
      entry = Entry.new(body, title)
      journal.add_entry(entry)
      $rerun = true

    when '2'
      journal.display_all
      $rerun = true
    when '3'
      print 'Search for: '.light_green
      query = gets.chomp
      search_query(journal, query)
    when '4'
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
    when '5'
      # delete_entry(journal)
      print 'Search for entry to delete: '.light_green
      query = gets.chomp
      results = search_query(journal, query)

      if results.any?
        print "Which entry to delete? (1-#{results.length}): ".light_green
        choice = gets.chomp.to_i - 1
        journal.delete_entry(results[choice])
        puts 'Deleted!'.light_green.bold
      end

    when '6'
      journal.save_to_file
      puts 'Goodbye!'.light_green.bold
      break
    else
      puts 'Invalid option!'.red
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

run # Start the program
