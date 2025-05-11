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
    CHECK
    MATE_TO_BLACK
    MATE_TO_WHITE
    STALEMATE
    ORDINARY
  end
  class Chess_piece
    attr_reader :color, :has_moves

    def initialize(color, owner_chessboard)
      @color = color
      @owner_chessboard = owner_chessboard
    end
  end
  class King < Chess_piese
  end
  class Queen < Chess_piese
  end
  class Rook < Chess_piese
  end
  class Bishop < Chess_piese
  end
  class Knight < Chess_piese
  end
  class Pawn < Chess_piese
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
          if piece.chess_piece.has_moves
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
