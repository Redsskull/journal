# frozen_string_literal: true

# Entry represent an instance of a journal entry. it has a body, a date and optionally a title.
# date is set either by the user or Time.
class Entry
  attr_reader :date
  attr_accessor :title, :body

  def initialize(body, title = '', date = nil)
    @date = date || Time.now.strftime('%y-%m-%d')
    @body = body
    @title = title
  end

  def display
    puts @date.light_green
    puts @title.light_green
    puts @body.light_blue
  end
end
