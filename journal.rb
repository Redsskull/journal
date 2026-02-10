require_relative 'entry'

class Journal
  attr_reader :entries

  def initialize(filename)
    @filename = filename
    @entries = []
  end

  def add_entry(entry)
    # Takes an Entry object, adds it to @entries array.
    @entries << entry
  end

  def save_to_file
    File.open(@filename, 'w') do |file|
      @entries.each do |entry|
        line = "#{entry.date}|#{entry.title}|#{entry.body}\n===END_ENTRY===\n"
        file.write(line)
      end
    end
  rescue StandardError => e
    puts "Couldn't save: #{e.message}".red
  end

  def load_from_file
    return unless File.exist?(@filename)

    file = File.read(@filename)
    # For each line:
    entries = file.split("===END_ENTRY===\n")
    # Split by "|" to get date, title, body
    entries.each do |entry|
      next if entry.strip.empty?

      parts = entry.split('|')
      date = parts[0]
      title = parts[1]
      body = parts[2]
      # Create Entry object
      entry = Entry.new(body, title, date)
      # Add to @entries array
      @entries << entry
    end
  rescue StandardError => e
    puts "Could not find file #{e.message}".red
  end

  def display_all
    @entries.each(&:display)
  end

  def search(term)
    # search take the users input and looks for what they typed.
    # They can search for a sentence, a data, a title etc.
    # This may need to display researchs in order if there are a few.
    matches = []
    search_term = term.downcase

    @entries.each do |entry|
      date_match = entry.date.downcase.include?(search_term)
      title_match = entry.title.downcase.include?(search_term)
      body_match = entry.body.downcase.include?(search_term)

      matches << entry if date_match || title_match || body_match
    end
    matches
  end

  def edit_entry(entry)
    puts 'If you do not wish to change following questions, simply click enter'.light_green
    print "New title?(current #{entry.title} ".light_green
    new_title = gets.chomp
    print "New body? (current #{entry.body}) ".light_green
    new_body = gets.chomp

    entry.title = new_title unless new_title.empty?
    entry.body = new_body unless new_body.empty?
  end

  def delete_entry(entry)
    # I think delete_entry needs to take in the exact entry name for certainty
    @entries.delete(entry)
  end
end
