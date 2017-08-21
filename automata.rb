require './cell_grid'
require './pattern'
require 'byebug'

class Automata
  attr_reader :grid

  def initialize(width, pattern)
    @grid = CellGrid.new(width)
    @grid[0, @grid.width/2] = 1

    @pattern = Pattern.new(pattern)
  end

  def loop(times)
    times.times do ||
      loop_once
    end
  end

  def loop_once
    @grid.add_row
    @grid.width.times do |column|
      @grid[@grid.height - 1, column] = @pattern.on(@grid.local_state(column)) ? '1' : '0'
    end
    # @grid.print_row(@grid.height - 1)
  end

  def width
    @grid.width
  end

  def height
    @grid.height
  end
end