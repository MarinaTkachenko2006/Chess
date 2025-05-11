# frozen_string_literal: true

require_relative "Chess/version"

module Chess
  class Error < StandardError; end
  module Color
    WHITE = 0
    BLACK = 1
  end
  OPPONENT = { Color::WHITE => Color::BLACK, Color::BLACK => Color::WHITE }
  module Position_type
    CHECK = 0
    MATE_TO_BLACK = 1
    MATE_TO_WHITE = 2
    STALEMATE = 3
    ORDINARY = 4
  end
  class Chess_piece
    attr_reader :color

    def initialize(color, owner_chessboard)
      @color = color
      @owner_chessboard = owner_chessboard
    end
  end
  class King < Chess_piece
    def initialize(color, owner_chessboard)
      super(color, owner_chessboard)
    end

    def valid_moves(cur_pos)
      moves = Set.new
      return moves
    end

    def valid_attacks(cur_pos)
      moves = Set.new
      return moves
    end

    def capture?(cur_pos, new_pos)
      return valid_attacks(cur_pos).include(new_pos)
    end

    def occupy?(cur_pos, new_pos)
      return valid_moves(cur_pos).include(new_pos)
    end

    def step_valid?(cur_pos, new_pos)
      return (capture?(cur_pos, new_pos) or occupy?(cur_pos, new_pos))
    end

    def make_step(cur_pos, new_pos)
    end

    def has_moves?(cur_pos)
      return (valid_moves(cur_pos).size > 0 or valid_attacks(cur_pos).size > 0)
    end
  end
  class Queen < Chess_piece
    def initialize(color, owner_chessboard)
      super(color, owner_chessboard)
    end
    
    def valid_moves(cur_pos)
      moves = Set.new
      return moves
    end

    def valid_attacks(cur_pos)
      moves = Set.new
      return moves
    end

    def capture?(cur_pos, new_pos)
      return valid_attacks(cur_pos).include(new_pos)
    end

    def occupy?(cur_pos, new_pos)
      return valid_moves(cur_pos).include(new_pos)
    end

    def step_valid?(cur_pos, new_pos)
      return (capture?(cur_pos, new_pos) or occupy?(cur_pos, new_pos))
    end

    def make_step(cur_pos, new_pos)
    end

    def has_moves?(cur_pos)
      return (valid_moves(cur_pos).size > 0 or valid_attacks(cur_pos).size > 0)
    end
  end
  class Rook < Chess_piece
    def initialize(color, owner_chessboard)
      super(color, owner_chessboard)
    end

    def valid_moves(cur_pos)
      moves = Set.new
      i = cur_pos[0] - 1
      while i >= 0 and @owner_chessboard.squares[i][cur_pos[1]].chess_piece == nil
        i -= 1
        moves.add([i, cur_pos[1]])
      end
      i = cur_pos[0] + 1
      while i < 8 and @owner_chessboard.squares[i][cur_pos[1]].chess_piece == nil
        i += 1
        moves.add([i, cur_pos[1]])
      end
      i = cur_pos[1] - 1
      while i >= 0 and @owner_chessboard.squares[cur_pos[0]][i].chess_piece == nil
        i -= 1
        moves.add([cur_pos[0], i])
      end
      i = cur_pos[1] + 1
      while i < 8 and @owner_chessboard.squares[cur_pos[0]][i].chess_piece == nil
        i += 1
        moves.add([cur_pos[0], i])
      end
      return moves
    end

    def valid_attacks(cur_pos)
      moves = Set.new
      i = cur_pos[0] - 1
      while i >= 0 and @owner_chessboard.squares[i][cur_pos[1]].chess_piece == nil
        i -= 1
      end
      if i >= 0
        p = @owner_chessboard.squares[i][cur_pos[1]].chess_piece
        if p != nil and p.color == OPPONENT[:color]
          moves.add([i, cur_pos[1]])
        end
      end
      i = cur_pos[0] + 1
      while i < 8 and @owner_chessboard.squares[i][cur_pos[1]].chess_piece == nil
        i += 1
      end
      if i < 8
        p = @owner_chessboard.squares[i][cur_pos[1]].chess_piece
        if p != nil and p.color == OPPONENT[:color]
          moves.add([i, cur_pos[1]])
        end
      end
      i = cur_pos[1] - 1
      while i >= 0 and @owner_chessboard.squares[cur_pos[0]][i].chess_piece == nil
        i -= 1
      end
      if i >= 0
        p = @owner_chessboard.squares[cur_pos[0]][i].chess_piece
        if p != nil and p.color == OPPONENT[:color]
          moves.add([cur_pos[0], i])
        end
      end
      i = cur_pos[1] + 1
      while i < 8 and @owner_chessboard.squares[cur_pos[0]][i].chess_piece == nil
        i += 1
      end
      if i < 8
        p = @owner_chessboard.squares[cur_pos[0]][i].chess_piece
        if p != nil and p.color == OPPONENT[:color]
          moves.add([cur_pos[0], i])
        end
      end
      return moves
    end

    def capture?(cur_pos, new_pos)
      return valid_attacks(cur_pos).include(new_pos)
    end

    def occupy?(cur_pos, new_pos)
      return valid_moves(cur_pos).include(new_pos)
    end

    def step_valid?(cur_pos, new_pos)
      return (capture?(cur_pos, new_pos) or occupy?(cur_pos, new_pos))
    end

    def make_step(cur_pos, new_pos)
    end

    def has_moves?(cur_pos)
      return (valid_moves(cur_pos).size > 0 or valid_attacks(cur_pos).size > 0)
    end
  end
  class Bishop < Chess_piece
    def initialize(color, owner_chessboard)
      super.initialize(color, owner_chessboard)
    end
    
    def valid_moves(cur_pos)
      moves = Set.new
      return moves
    end

    def valid_attacks(cur_pos)
      moves = Set.new
      return moves
    end

    def capture?(cur_pos, new_pos)
      return valid_attacks(cur_pos).include(new_pos)
    end

    def occupy?(cur_pos, new_pos)
      return valid_moves(cur_pos).include(new_pos)
    end

    def step_valid?(cur_pos, new_pos)
      return (capture?(cur_pos, new_pos) or occupy?(cur_pos, new_pos))
    end

    def make_step(cur_pos, new_pos)
    end

    def has_moves?(cur_pos)
      return (valid_moves(cur_pos).size > 0 or valid_attacks(cur_pos).size > 0)
    end
  end
  class Knight < Chess_piece
    def initialize(color, owner_chessboard)
      super(color, owner_chessboard)
    end
    
    def valid_moves(cur_pos)
      moves = Set.new
      if cur_pos[0] - 1 >= 0 and cur_pos[1] - 2 >= 0
        p = @owner_chessboard.squares[cur_pos[0] - 1][cur_pos[1] - 2]
        if p == nil then moves.add([cur_pos[0] - 1, cur_pos[1] - 2]) end
      end
      if cur_pos[0] - 1 >= 0 and cur_pos[1] + 2 < 8
        p = @owner_chessboard.squares[cur_pos[0] - 1][cur_pos[1] + 2]
        if p == nil then moves.add([cur_pos[0] - 1, cur_pos[1] + 2]) end
      end
      if cur_pos[0] - 2 >= 0 and cur_pos[1] - 1 >= 0
        p = @owner_chessboard.squares[cur_pos[0] - 2][cur_pos[1] - 1]
        if p == nil then moves.add([cur_pos[0] - 2, cur_pos[1] - 1]) end
      end
      if cur_pos[0] - 2 >= 0 and cur_pos[1] + 1 < 8
        p = @owner_chessboard.squares[cur_pos[0] - 2][cur_pos[1] + 1]
        if p == nil then moves.add([cur_pos[0] - 2, cur_pos[1] + 1]) end
      end
      if cur_pos[0] + 1 < 8 and cur_pos[1] - 2 >= 0
        p = @owner_chessboard.squares[cur_pos[0] + 1][cur_pos[1] - 2]
        if p == nil then moves.add([cur_pos[0] + 1, cur_pos[1] - 2]) end
      end
      if cur_pos[0] + 1 < 8 and cur_pos[1] + 2 < 8
        p = @owner_chessboard.squares[cur_pos[0] + 1][cur_pos[1] + 2]
        if p == nil then moves.add([cur_pos[0] + 1, cur_pos[1] + 2]) end
      end
      if cur_pos[0] + 2 < 8 and cur_pos[1] - 1 >= 0
        p = @owner_chessboard.squares[cur_pos[0] + 2][cur_pos[1] - 1]
        if p == nil then moves.add([cur_pos[0] + 2, cur_pos[1] - 1]) end
      end
      if cur_pos[0] + 2 < 8 and cur_pos[1] + 1 < 8
        p = @owner_chessboard.squares[cur_pos[0] + 2][cur_pos[1] + 1]
        if p == nil then moves.add([cur_pos[0] + 2, cur_pos[1] + 1]) end
      end
      return moves
    end

    def valid_attacks(cur_pos)
      moves = Set.new
      if cur_pos[0] - 1 >= 0 and cur_pos[1] - 2 >= 0
        p = @owner_chessboard.squares[cur_pos[0] - 1][cur_pos[1] - 2]
        if p == nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] - 1, cur_pos[1] - 2]) end
      end
      if cur_pos[0] - 1 >= 0 and cur_pos[1] + 2 < 8
        p = @owner_chessboard.squares[cur_pos[0] - 1][cur_pos[1] + 2]
        if p != nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] - 1, cur_pos[1] + 2]) end
      end
      if cur_pos[0] - 2 >= 0 and cur_pos[1] - 1 >= 0
        p = @owner_chessboard.squares[cur_pos[0] - 2][cur_pos[1] - 1]
        if p == nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] - 2, cur_pos[1] - 1]) end
      end
      if cur_pos[0] - 2 >= 0 and cur_pos[1] + 1 < 8
        p = @owner_chessboard.squares[cur_pos[0] - 2][cur_pos[1] + 1]
        if p == nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] - 2, cur_pos[1] + 1]) end
      end
      if cur_pos[0] + 1 < 8 and cur_pos[1] - 2 >= 0
        p = @owner_chessboard.squares[cur_pos[0] + 1][cur_pos[1] - 2]
        if p == nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] + 1, cur_pos[1] - 2]) end
      end
      if cur_pos[0] + 1 < 8 and cur_pos[1] + 2 < 8
        p = @owner_chessboard.squares[cur_pos[0] + 1][cur_pos[1] + 2]
        if p == nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] + 1, cur_pos[1] + 2]) end
      end
      if cur_pos[0] + 2 < 8 and cur_pos[1] - 1 >= 0
        p = @owner_chessboard.squares[cur_pos[0] + 2][cur_pos[1] - 1]
        if p == nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] + 2, cur_pos[1] - 1]) end
      end
      if cur_pos[0] + 2 < 8 and cur_pos[1] + 1 < 8
        p = @owner_chessboard.squares[cur_pos[0] + 2][cur_pos[1] + 1]
        if p == nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] + 2, cur_pos[1] + 1]) end
      end
      return moves
    end

    def capture?(cur_pos, new_pos)
      return valid_attacks(cur_pos).include(new_pos)
    end

    def occupy?(cur_pos, new_pos)
      return valid_moves(cur_pos).include(new_pos)
    end

    def step_valid?(cur_pos, new_pos)
      return (capture?(cur_pos, new_pos) or occupy?(cur_pos, new_pos))
    end

    def make_step(cur_pos, new_pos)
    end

    def has_moves?(cur_pos)
      return (valid_moves(cur_pos).size > 0 or valid_attacks(cur_pos).size > 0)
    end
  end
  class Pawn < Chess_piece
    def initialize(color, owner_chessboard)
      super(color, owner_chessboard)
      @already_moved = false
    end

    def valid_attacks(cur_pos)
      moves = Set.new
      h = :color == Color::WHITE ? cur_pos[0] + 1 : cur_pos[0] - 1
      
      if h.between?(0, 7_)
        if cur_pos[1] - 1 >= 0
          p = @owner_chessboard.squares[h][cur_pos[1] - 1].chess_piece
          if p != nil and p.color == OPPONENT[:color] then moves.add([h, cur_pos[1] - 1]) end
        end
        if cur_pos[1] + 1 < 8
          p = @owner_chessboard.squares[h][cur_pos[1] + 1].chess_piece
          if p != nil and p.color == OPPONENT[:color] then moves.add([h, cur_pos[1] + 1]) end
        end
      end
      return moves
    end

    def valid_moves(cur_pos)
      moves = Set.new
      h = :color == Color::WHITE ? cur_pos[0] + 1 : cur_pos[0] - 1
      if h.between?(0, 7)
        p = @owner_chessboard.squares[h][cur_pos[1]].chess_piece
        if p != nil and p.color == OPPONENT[:color] then moves.add([h, cur_pos[1]]) end
      end
      if @already_moved == false
        if :color == Color::WHITE then hh = cur_pos[0] + 2 else hh = cur_pos[0] - 2 end
        p = @owner_chessboard.squares[h][cur_pos[1]].chess_piece
        pp = @owner_chessboard.squares[hh][cur_pos[1]].chess_piece
        if p == nil and pp == nil then moves.add([hh, cur_pos[1]]) end
      end
      return moves
    end

    def capture?(cur_pos, new_pos)
      return valid_attacks(cur_pos).include(new_pos)
    end

    def occupy?(cur_pos, new_pos)
      return valid_moves(cur_pos).include(new_pos)
    end

    def step_valid?(cur_pos, new_pos)
      return (capture?(cur_pos, new_pos) or occupy?(cur_pos, new_pos))
    end

    def make_step(cur_pos, new_pos)
      @already_moved = true
    end

    def has_moves?(cur_pos)
      return (valid_moves(cur_pos).size > 0 or valid_attacks(cur_pos).size > 0)
    end
  end
  class Square
    attr_accessor :attacked_by, :king_position, :chess_piece

    def initialize(chess_piece = nil)
      @chess_piece = chess_piece
      @attacked_by = { Color::WHITE => Set.new, Color::BLACK => Set.new }
    end
  end
  class Chessboard
    attr_accessor :squares

    attr_reader :king_position, :position_type, :player_color

    def initialize
      # Инициализация шахматной сетки

      @squares = Array.new(8) { Array.new(8) { Square.new } }

      # Инициализация белых фигур

      @squares[0][0].chess_piece = Rook.new(Color::WHITE, self)
      @squares[0][1].chess_piece = Knight.new(Color::WHITE, self)
      @squares[0][2].chess_piece = Bishop.new(Color::WHITE, self)
      @squares[0][3].chess_piece = King.new(Color::WHITE, self)
      @squares[0][4].chess_piece = Queen.new(Color::WHITE, self)
      @squares[0][5].chess_piece = Bishop.new(Color::WHITE, self)
      @squares[0][6].chess_piece = Knight.new(Color::WHITE, self)
      @squares[0][7].chess_piece = Rook.new(Color::WHITE, self)

      for piece in @squares[1]
        piece.chess_piece = Pawn.new(Color::WHITE, self)
      end

      # Инициализация чёрных фигур

      @squares[7][0].chess_piece = Rook.new(Color::BLACK, self)
      @squares[7][1].chess_piece = Knight.new(Color::BLACK, self)
      @squares[7][2].chess_piece = Bishop.new(Color::BLACK, self)
      @squares[7][3].chess_piece = King.new(Color::BLACK, self)
      @squares[7][4].chess_piece = Queen.new(Color::BLACK, self)
      @squares[7][5].chess_piece = Bishop.new(Color::BLACK, self)
      @squares[7][6].chess_piece = Knight.new(Color::BLACK, self)
      @squares[7][7].chess_piece = Rook.new(Color::BLACK, self)
      
      for piece in @squares[6]
        piece.chess_piece = Pawn.new(Color::BLACK, self)
      end
      
      @king_position = { :WHITE => @squares[0][3], :BLACK => @squares[7][3] }
      update()
    end

    def update()
      (0..7).each do |i|
        (0..7).each do |j|
          square = @squares[i][j]
          next if square.chess_piece.nil? 

          piece = square.chess_piece

          valid_attacks = piece.valid_attacks([i, j]) 
          valid_attacks.each do |pos|
            next if @squares[pos[0]].nil? || @squares[pos[0]][pos[1]].nil? 
            @squares[pos[0]][pos[1]].attacked_by[piece.color] = true
          end
        end
      end
    end

    def make_step(cur_pos, new_pos)
      if @king_position[OPPONENT[:player_color]].attacked_by[:player_color] == true
        if :player_color == Color::WHITE 
          @position_type = Position_type::MATE_TO_BLACK 
        else 
          @position_type = Position_type::MATE_TO_WHITE
        end
        return
      end

      has_moves = false

      @squares.each do |row|
        row.each do |square|
          if square.chess_piece && square.chess_piece.color == @player_color
            has_moves = true if square.chess_piece.has_moves?(cur_pos)
          end
        end
      end

      if (!has_moves)
        if @king_position[:player_color].attacked_by[OPPONENT[:player_color]] == true
          if :player_color == Color::BLACK 
            @position_type = Position_type::MATE_TO_BLACK 
          else 
            @position_type = Position_type::MATE_TO_WHITE
          end
        else 
          @position_type = Position_type::STALEMATE
        end
        return
      end
      # Здесь будет ошибка, т.к. @squares[new_pos[0]][new_pos[1]].chess_piece == nil
      if @squares[new_pos[0]][new_pos[1]].chess_piece.step_valid?(cur_pos, new_pos)
        @squares[new_pos[0]][new_pos[1]].chess_piece.make_step(cur_pos, new_pos)
        @squares[new_pos[0]][new_pos[1]].chess_piece = @squares[cur_pos[0]][cur_pos[1]].chess_piece
        @squares[cur_pos[0]][cur_pos[1]].chess_piece = nil
      end
      if @king_position[OPPONENT[:player_color]].attacked_by[:player_color] == true
        @position_type = Position_type::CHECK
      else
        @position_type = Position_type::ORDINARY
      end
      update()
    end

  end
  class Chess
  end
end
