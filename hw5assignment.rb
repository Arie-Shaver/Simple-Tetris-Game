class MyPiece < Piece
  All_My_Pieces = All_Pieces + [rotations([[0, 0], [-1, 0], [1, 0], [0, 1], [1, 1]]),
                               [[[0, 0], [-1, 0], [1, 0], [2, 0], [-2, 0]], 
                               [[0, 0], [0, -1], [0, 1], [0, 2], [0, -2]]],
                               rotations([[0, 0], [1, 0], [0, 1]]),]
  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  def self.cheat_piece (board)
    MyPiece.new([[0,0]], board)
  end
end

class MyBoard < Board
  def next_piece
    if @cheat
      @current_block = MyPiece.cheat_piece(self)
      @cheat = false
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, -1)
      @current_block.move(0, 0, -1)
    end
    draw
  end

  def cheat_move
    if score >= 100 and !@cheat
      @cheat = true
      @score -= 100
    else
      @score+=0
    end
  end

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.size - 1)).each{|index| 
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end
end

class MyTetris < Tetris
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super
    @root.bind('u', proc {@board.rotate_180}) 
    @root.bind('c', proc {@board.cheat_move})
    end
end


