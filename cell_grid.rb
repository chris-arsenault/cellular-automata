class CellGrid
  attr_reader :width, :cells

  def initialize(width, locality = 1)
   @locality = locality

    if width %2 == 0
      width += 1
    end
    @width = width

    @cells = []
    @cells.push(Array.new(@width) { '0' })
    @drawn = {}
  end

  def height
    @cells.length
  end

  def local_state(column)
    result = ''
    ((column - @locality)..(column + @locality)).to_a.each do |r|
      if r < 0 || r > width - 1
        result += '0'
      else
        result += @cells[height - 2][r].to_s
      end
    end
    result
  end

  def add_row
    @cells.push(Array.new(@width))
  end

  def print_row(row)
    puts @cells[row].join('')
  end

  def [](row, column)
    @cells[row][column]
  end

  def []=(row, column, value)
    @cells[row][column] = value
  end

  def drawn(row)
    @drawn[row]
  end

  def set_drawn(row)
    @drawn[row] = true
  end
end