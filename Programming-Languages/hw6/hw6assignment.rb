# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.
class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces =All_Pieces + [rotations([[0, 0], [-1, 0], [-1, 1], [0, 1], [1, 0]]),# first
                [[[0, 0], [-2, 0], [-1, 0], [1, 0], [2, 0]],
                [[0, 0], [0, -2], [0, -1], [0, 1], [0, 2]]],  # long
               rotations([[0, 0], [0, 1], [1, 0]])] # third enhancement block

  # your enhancements here
  def self.next_piece (board)
      MyPiece.new(All_My_Pieces.sample, board)
  end
end

class MyBoard < Board
  # your enhancements here
  def initialize (game)
      super
      @cheating = false
      next_piece
  end
  # define the behavior of cheat
  def cheat
      if !@cheating && @score>=100
          @cheating = true
          @score -= 100
      end
  end

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    # number of points may be not 3, though it is true in original version
    (0..(locations.size-1)).each{|index| 
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end

  def next_piece
      if !@cheating
          @current_block = MyPiece.next_piece(self)
          @current_pos = nil
      else
          @cheating = false
          @current_block = MyPiece.new([[[0, 0]]], self)
          @current_pos = nil
      end
  end
end

class MyTetris < Tetris
  # your enhancements here

  def key_bindings  
    super
    @root.bind('u', proc {@board.rotate_clockwise; @board.rotate_clockwise})
    @root.bind('c', proc {@board.cheat})
  end

  def set_board
    @canvas = TetrisCanvas.new
    # need to change this line of code
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end
end

