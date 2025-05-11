# frozen_string_literal: true

require_relative "Chess/version"

module Chess
  class Error < StandardError; end
  module Color
    WHITE = 0
    BLACK = 1
  end
  OPPONENT = { WHITE => BLACK, BLACK => WHITE }
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
  class Queen < Chess_piece
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
  class Rook < Chess_piece
    def initialize(color, owner_chessboard)
      super.initialize(color, owner_chessboard)
    end

    def valid_moves(cur_pos)
      moves = Set.new
      i = cur_pos[0] - 1
      while i >= 0 and owner_chessboard.squares[i][cur_pos[1]].chess_piece == nil
        i -= 1
        moves.add([i, cur_pos[1]])
      end
      i = cur_pos[0] + 1
      while i < 8 and owner_chessboard.squares[i][cur_pos[1]].chess_piece == nil
        i += 1
        moves.add([i, cur_pos[1]])
      end
      i = cur_pos[1] - 1
      while i >= 0 and owner_chessboard.squares[cur_pos[0]][i].chess_piece == nil
        i -= 1
        moves.add([cur_pos[0], i])
      end
      i = cur_pos[1] + 1
      while i < 8 and owner_chessboard.squares[cur_pos[0]][i].chess_piece == nil
        i += 1
        moves.add([cur_pos[0], i])
      end
      return moves
    end

    def valid_attacks(cur_pos)
      moves = Set.new
      i = cur_pos[0] - 1
      while i >= 0 and owner_chessboard.squares[i][cur_pos[1]].chess_piece == nil
        i -= 1
      end
      if i >= 0
        p = owner_chessboard.squares[i][cur_pos[1]].chess_piece
        if p != nil and p.color == OPPONENT[:color]
          moves.add([i, cur_pos[1]])
        end
      end
      i = cur_pos[0] + 1
      while i < 8 and owner_chessboard.squares[i][cur_pos[1]].chess_piece == nil
        i += 1
      end
      if i < 8
        p = owner_chessboard.squares[i][cur_pos[1]].chess_piece
        if p != nil and p.color == OPPONENT[:color]
          moves.add([i, cur_pos[1]])
        end
      end
      i = cur_pos[1] - 1
      while i >= 0 and owner_chessboard.squares[cur_pos[0]][i].chess_piece == nil
        i -= 1
      end
      if i >= 0
        p = owner_chessboard.squares[cur_pos[0]][i].chess_piece
        if p != nil and p.color == OPPONENT[:color]
          moves.add([cur_pos[0], i])
        end
      end
      i = cur_pos[1] + 1
      while i < 8 and owner_chessboard.squares[cur_pos[0]][i].chess_piece == nil
        i += 1
      end
      if i < 8
        p = owner_chessboard.squares[cur_pos[0]][i].chess_piece
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
      super.initialize(color, owner_chessboard)
    end
    
    def valid_moves(cur_pos)
      moves = Set.new
      if cur_pos[0] - 1 >= 0 and cur_pos[1] - 2 >= 0
        p = owner_chessboard.squares[cur_pos[0] - 1][cur_pos[1] - 2]
        if p == nil then moves.add([cur_pos[0] - 1, cur_pos[1] - 2]) end
      end
      if cur_pos[0] - 1 >= 0 and cur_pos[1] + 2 < 8
        p = owner_chessboard.squares[cur_pos[0] - 1][cur_pos[1] + 2]
        if p == nil then moves.add([cur_pos[0] - 1, cur_pos[1] + 2]) end
      end
      if cur_pos[0] - 2 >= 0 and cur_pos[1] - 1 >= 0
        p = owner_chessboard.squares[cur_pos[0] - 2][cur_pos[1] - 1]
        if p == nil then moves.add([cur_pos[0] - 2, cur_pos[1] - 1]) end
      end
      if cur_pos[0] - 2 >= 0 and cur_pos[1] + 1 < 8
        p = owner_chessboard.squares[cur_pos[0] - 2][cur_pos[1] + 1]
        if p == nil then moves.add([cur_pos[0] - 2, cur_pos[1] + 1]) end
      end
      if cur_pos[0] + 1 < 8 and cur_pos[1] - 2 >= 0
        p = owner_chessboard.squares[cur_pos[0] + 1][cur_pos[1] - 2]
        if p == nil then moves.add([cur_pos[0] + 1, cur_pos[1] - 2]) end
      end
      if cur_pos[0] + 1 < 8 and cur_pos[1] + 2 < 8
        p = owner_chessboard.squares[cur_pos[0] + 1][cur_pos[1] + 2]
        if p == nil then moves.add([cur_pos[0] + 1, cur_pos[1] + 2]) end
      end
      if cur_pos[0] + 2 < 8 and cur_pos[1] - 1 >= 0
        p = owner_chessboard.squares[cur_pos[0] + 2][cur_pos[1] - 1]
        if p == nil then moves.add([cur_pos[0] + 2, cur_pos[1] - 1]) end
      end
      if cur_pos[0] + 2 < 8 and cur_pos[1] + 1 < 8
        p = owner_chessboard.squares[cur_pos[0] + 2][cur_pos[1] + 1]
        if p == nil then moves.add([cur_pos[0] + 2, cur_pos[1] + 1]) end
      end
      return moves
    end

    def valid_attacks(cur_pos)
      moves = Set.new
      if cur_pos[0] - 1 >= 0 and cur_pos[1] - 2 >= 0
        p = owner_chessboard.squares[cur_pos[0] - 1][cur_pos[1] - 2]
        if p == nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] - 1, cur_pos[1] - 2]) end
      end
      if cur_pos[0] - 1 >= 0 and cur_pos[1] + 2 < 8
        p = owner_chessboard.squares[cur_pos[0] - 1][cur_pos[1] + 2]
        if p != nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] - 1, cur_pos[1] + 2]) end
      end
      if cur_pos[0] - 2 >= 0 and cur_pos[1] - 1 >= 0
        p = owner_chessboard.squares[cur_pos[0] - 2][cur_pos[1] - 1]
        if p == nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] - 2, cur_pos[1] - 1]) end
      end
      if cur_pos[0] - 2 >= 0 and cur_pos[1] + 1 < 8
        p = owner_chessboard.squares[cur_pos[0] - 2][cur_pos[1] + 1]
        if p == nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] - 2, cur_pos[1] + 1]) end
      end
      if cur_pos[0] + 1 < 8 and cur_pos[1] - 2 >= 0
        p = owner_chessboard.squares[cur_pos[0] + 1][cur_pos[1] - 2]
        if p == nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] + 1, cur_pos[1] - 2]) end
      end
      if cur_pos[0] + 1 < 8 and cur_pos[1] + 2 < 8
        p = owner_chessboard.squares[cur_pos[0] + 1][cur_pos[1] + 2]
        if p == nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] + 1, cur_pos[1] + 2]) end
      end
      if cur_pos[0] + 2 < 8 and cur_pos[1] - 1 >= 0
        p = owner_chessboard.squares[cur_pos[0] + 2][cur_pos[1] - 1]
        if p == nil and p.color == OPPONENT[:color] then moves.add([cur_pos[0] + 2, cur_pos[1] - 1]) end
      end
      if cur_pos[0] + 2 < 8 and cur_pos[1] + 1 < 8
        p = owner_chessboard.squares[cur_pos[0] + 2][cur_pos[1] + 1]
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
      super.initialize(color, owner_chessboard)
      @already_moved = false
    end

    def valid_attacks(cur_pos)
      moves = Set.new
      if :color == WHITE then h = cur_pos[0] + 1 else h = cur_pos[0] - 1 end
      if h >= 0 and h < 8
        if cur_pos[1] - 1 >= 0
          p = owner_chessboard.squares[h][cur_pos[1] - 1].chess_piece
          if p != nil and p.color == OPPONENT[:color] then moves.add([h, cur_pos[1] - 1]) end
        end
        if cur_pos[1] + 1 < 8
          p = owner_chessboard.squares[h][cur_pos[1] + 1].chess_piece
          if p != nil and p.color == OPPONENT[:color] then moves.add([h, cur_pos[1] + 1]) end
        end
      end
    end

    def valid_moves(cur_pos)
      moves = Set.new
      if :color == WHITE then h = cur_pos[0] + 1 else h = cur_pos[0] - 1 end
      if h >= 0 and h < 8
        p = owner_chessboard.squares[h][cur_pos[1]].chess_piece
        if p != nil and p.color == OPPONENT[:color] then moves.add([h, cur_pos[1]]) end
      end
      if @already_moved == false
        if :color == WHITE then hh = cur_pos[0] + 2 else hh = cur_pos[0] - 2 end
        p = owner_chessboard.squares[h][cur_pos[1]].chess_piece
        pp = owner_chessboard.squares[hh][cur_pos[1]].chess_piece
        if p == nil and pp == nil then moves.add([hh, cur_pos[1]]) end
      end
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
      @attacked_by = { WHITE => Set.new, BLACK => Set.new }
    end
  end
  class Chessboard
    attr_accessor :squares

    attr_reader :king_position, :position_type, :player_color

    def initialize
      @squares = Array.new
      i = 0
      while i < 8
        i += 1
        @squares << Array.new
        j = 0
        while j < 8
          j += 1
          @squares[i] << Square.new
        end
      end
      @squares[0][0].chess_piece = Rook.new(WHITE, self)
      @squares[0][1].chess_piece = Knight.new(WHITE, self)
      @squares[0][2].chess_piece = Bishop.new(WHITE, self)
      @squares[0][3].chess_piece = King.new(WHITE, self)
      @squares[0][4].chess_piece = Queen.new(WHITE, self)
      @squares[0][5].chess_piece = Bishop.new(WHITE, self)
      @squares[0][6].chess_piece = Knight.new(WHITE, self)
      @squares[0][7].chess_piece = Rook.new(WHITE, self)
      for piece in @squares[1]
        piece.chess_piece = Pawn.new(WHITE, self)
      end
      for piece in @squares[6]
        piece.chess_piece = Pawn.new(BLACK, self)
      end
      @squares[7][0].chess_piece = Rook.new(BLACK, self)
      @squares[7][1].chess_piece = Knight.new(BLACK, self)
      @squares[7][2].chess_piece = Bishop.new(BLACK, self)
      @squares[7][3].chess_piece = King.new(BLACK, self)
      @squares[7][4].chess_piece = Queen.new(BLACK, self)
      @squares[7][5].chess_piece = Bishop.new(BLACK, self)
      @squares[7][6].chess_piece = Knight.new(BLACK, self)
      @squares[7][7].chess_piece = Rook.new(BLACK, self)
      @king_position = { :WHITE => @squares[0][3], :BLACK => @squares[7][3] }
      update()
    end

    def update()
      i = 0
      while i < 8
        j = 0
        while j < 8
          for pos in @squares[i][j].chess_piece.valid_attacks([i, j])
            @squares[pos[0]][pos[1]].attacked_by[@squares[i][j].chess_piece.color] = true
          end
          j += 1
        end
        i += 1
      end
    end

    def make_step(cur_pos, new_pos)
      if @king_position[OPPONENT[:player_color]].attacked_by[:player_color] == true
        if :player_color == WHITE 
          @position_type = Position_type::MATE_TO_BLACK 
        else 
          @position_type = Position_type::MATE_TO_WHITE
        end
        return
      end
      has_moves = false
      for piece in @squares
        if piece.chess_piece != nil and piece.chess_piece.color = :player_color
          if piece.chess_piece.has_moves?(cur_pos)
            has_moves = true
          end
        end
      end
      if (!has_moves)
        if @king_position[:player_color].attacked_by[OPPONENT[:player_color]] == true
          if :player_color == BLACK 
            @position_type = Position_type::MATE_TO_BLACK 
          else 
            @position_type = Position_type::MATE_TO_WHITE
          end
        else 
          @position_type = Position_type::STALEMATE
        end
        return
      end
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
