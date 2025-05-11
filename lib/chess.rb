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
    attr_reader :color, :has_moves

    def initialize(color, owner_chessboard)
      @color = color
      @owner_chessboard = owner_chessboard
    end
  end
  class King < Chess_piese
    def initialize(color, owner_chessboard)
      super.initialize(color, owner_chessboard)
    end
  end
  class Queen < Chess_piese
    def initialize(color, owner_chessboard)
      super.initialize(color, owner_chessboard)
    end
  end
  class Rook < Chess_piese
    def initialize(color, owner_chessboard)
      super.initialize(color, owner_chessboard)
    end
  end
  class Bishop < Chess_piese
    def initialize(color, owner_chessboard)
      super.initialize(color, owner_chessboard)
    end
  end
  class Knight < Chess_piese
    def initialize(color, owner_chessboard)
      super.initialize(color, owner_chessboard)
    end
  end
  class Pawn < Chess_piese
    def initialize(color, owner_chessboard)
      super.initialize(color, owner_chessboard)
      @count_moves = 0
    end

    def right_direction?(cur_pos, new_pos)
      if :color == WHITE and new_pos[0] > cur_pos[0]
        return true
      end
      if :color == BLACK and new_pos[0] < cur_pos[0]
        return true
      end
    end

    def long_step?(cur_pos, new_pos)
      if right_direction?(cur_pos, new_pos) and (new_pos[0] - cur_pos[0]).abs == 2
        if @count_moves == 0
          return true
        end
        return false
      end
      return false
    end

    def short_step?(cur_pos, new_pos)
      if right_direction?(cur_pos, new_pos) and (new_pos[0] - cur_pos[0]).abs == 1
        return true
      end
      return false
    end

    def occupy?(cur_pos, new_pos)
      if new_pos[1] == cur_pos[1] and (long_step?(cur_pos, new_pos) or short_step?(cur_pos, new_pos))
        return true
      end
      return false
    end

    def capture?(cur_pos, new_pos)
      if right_direction?(cur_pos, new_pos) and (new_pos[1] - cur_pos[1]).abs == 1
        return true
      end
      return false
    end

    def en_passant?(cur_pos, new_pos)
      if capture?(cur_pos, new_pos)
        if :color == WHITE
          if new_pos[0] == 5 
            p = owner_chessboard.squares[4][new_pos[1]].chess_piece
            if p != nil and p.is_a?(Pawn) and p.count_moves == 1
              owner_chessboard.squares[4][new_pos[1]].chess_piece = nil
              return true
            end
          end
        else
          if new_pos[0] == 2 
            p = owner_chessboard.squares[3][new_pos[1]].chess_piece
            if p != nil and p.is_a?(Pawn) and p.count_moves == 1
              owner_chessboard.squares[3][new_pos[1]].chess_piece = nil
              return true
            end
          end
        end
      end
      return false
    end

    def update(cur_pos, new_pos)
      if :color == WHITE
        h = cur_pos[0] + 1
        nh = new_pos[0] + 1
      else
        h = cur_pos[0] - 1
        nh = new_pos[0] - 1
      end
      if h >=0 and h < 8
        if cur_pos[1] - 1 >= 0
          owner_chessboard.squares[h][cur_pos[1] - 1].attacked_by[:color].delete(cur_pos)
        end
       if cur_pos[1] + 1 < 8
          owner_chessboard.squares[h][cur_pos[1] + 1].attacked_by[:color].delete(cur_pos)
       end
      end
      if nh >=0 and nh < 8
        if new_pos[1] - 1 >= 0
         owner_chessboard.squares[nh][new_pos[1] - 1].attacked_by[:color].add(new_pos)
        end
       if new_pos[1] + 1 < 8
          owner_chessboard.squares[nh][new_pos[1] + 1].attacked_by[:color].add(new_pos)
       end
      end
    end

    def step_valid?(cur_pos, new_pos)
      if owner_chessboard.squares[new_pos[0]][new_pos[1]] == nil
        if occupy?(cur_pos, new_pos) or en_passant?(cur_pos, new_pos)
          @count_moves += 1
          update(cur_pos, new_pos)
          return true
        end
      else
        if capture?(cur_pos, new_pos)
          @count_moves += 1
          update(cur_pos, new_pos)
          return true
        end
      end
      return false
    end

    def has_moves?(cur_pos)
      if cur_pos[0] + 1 < 8
        if step_valid?(cur_pos, [cur_pos[0] + 1, cur_pos[1]]) then return true end
        if cur_pos[1] + 1 < 8 and step_valid?(cur_pos, [cur_pos[0] + 1, cur_pos[1] + 1]) 
          return true 
        end
        if cur_pos[1] - 1 >= 0 and step_valid?(cur_pos, [cur_pos[0] + 1, cur_pos[1] - 1]) 
          return true 
        end
      end
      if cur_pos[0] - 1 >= 0
        if step_valid?(cur_pos, [cur_pos[0] - 1, cur_pos[1]]) then return true end
        if cur_pos[1] + 1 < 8 and step_valid?(cur_pos, [cur_pos[0] - 1, cur_pos[1] + 1]) 
          return true 
        end
        if cur_pos[1] - 1 >= 0 and step_valid?(cur_pos, [cur_pos[0] - 1, cur_pos[1] - 1]) 
          return true 
        end
      end
      return false
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
    end

    def make_step(cur_pos, new_pos)
      if @king_position[OPPONENT[:player_color]].attacked_by[:player_color].size > 0
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
        if @king_position[:player_color].attacked_by[OPPONENT[:player_color]].size > 0
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
        @squares[new_pos[0]][new_pos[1]].chess_piece = @squares[cur_pos[0]][cur_pos[1]].chess_piece
        @squares[cur_pos[0]][cur_pos[1]].chess_piece = nil
      end
      if @king_position[OPPONENT[:player_color]].attacked_by[:player_color].size > 0
        @position_type = Position_type::CHECK
      else
        @position_type = Position_type::ORDINARY
      end
    end
  end
  class Chess
  end
end
