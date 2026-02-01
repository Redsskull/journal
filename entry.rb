class Entry
  attr_reader :date
  attr_accessor :title, :body

  def initialize(body, title = '', _date = nil)
    @date = date || Time.now.strftime('%y-%m-%d')
    @body = body
    @title = title
  end

  def display
    puts "#{@date}".light_green
    puts "#{@title}".light_green
    puts "#{@body}".light_blue
  end
end
