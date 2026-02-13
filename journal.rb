require_relative 'entry'

class Journal
  attr_reader :entries, :filename

  def initialize(filename)
    @filename = filename
    @entries = []
  end

  def add_entry(entry)
    # Takes an Entry object, adds it to @entries array.
    @entries << entry
  end

  def save_to_file
    Dir.mkdir('data') unless Dir.exist?('data')
    File.open(File.join('data', @filename), 'w') do |file|
      @entries.each do |entry|
        line = "#{entry.date}|#{entry.title}|#{entry.body}\n===END_ENTRY===\n"
        file.write(line)
      end
    end
  rescue StandardError => e
    puts "Couldn't save: #{e.message}".red
  end

  def load_from_file
    return unless File.exist?("data/#{@filename}")

    file = File.read("data/#{@filename}")
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

  def export(format)
    base_name = File.basename(@filename, '.*')

    case format
    when 'plaintext(txt)'
      actual_format = 'txt'
      export_as_plain_text("#{base_name}_exported.#{actual_format}")
    when 'markdown'
      actual_format = 'md'
      export_as_markdown("#{base_name}_exported.#{actual_format}")
    when 'pdf'
      export_as_pdf("#{base_name}_exported.pdf")
    else
      puts "Unknown format: #{format}".red
    end
  end

  private

  def export_as_plain_text(filename)
    line_width = 80
    File.open(filename, 'w') do |file|
      @entries.each do |entry|
        spaces = line_width - entry.date.length - entry.title.length
        separator = '* * * * *'
        spaces_before_stars = (line_width - separator.length) / 2
        centered_stars = "#{' ' * spaces_before_stars}#{separator}"
        header = "#{entry.date}#{' ' * spaces}#{entry.title}"
        output = <<~ENTRY
          #{header}

          #{entry.body}

          #{centered_stars}
        ENTRY
        file.write(output)
      end
    end
    puts "Exported to #{filename}!".green
  rescue StandardError => e
    puts "Export failed: #{e.message}".red
  end

  def export_as_markdown(filename)
    File.open(filename, 'w') do |file|
      @entries.each do |entry|
        markdown = <<~MD
          ## #{entry.title}

          *#{entry.date}*

          #{entry.body}

          ---

        MD
        file.write(markdown)
      end
    end
    puts "Exported to #{filename}!".green
  rescue StandardError => e
    puts "Export failed #{e.messgae}".red
  end

  def export_as_pdf(filename)
    Prawn::Document.generate(filename) do |pdf|
      @entries.each do |entry|
        pdf.text entry.title, size: 18, style: :bold
        pdf.text entry.date, size: 10, style: :italic
        pdf.move_down 10
        pdf.text entry.body
        pdf.move_down 10
        pdf.text '-' * 50 # ← Use regular hyphen, not em-dash!
        pdf.move_down 20
      end
    end
    puts "Exported to #{filename}!".green
  rescue StandardError => e
    puts "Export failed: #{e.message}".red
  end
end
