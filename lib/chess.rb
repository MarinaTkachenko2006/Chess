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
      @already_moved = false
    end

    def valid_moves(cur_pos)
      moves = Set.new
      directions = [
        [-1, -1], [0, -1], 
        [1, -1], [1, 0], 
        [1, 1], [0, 1], 
        [-1, 1], [-1, 0]
      ]

      directions.each do |dx, dy|
        new_x = cur_pos[0] + dx
        new_y = cur_pos[1] + dy
        if new_x.between?(0, 7) && new_y.between?(0, 7)
          if !@owner_chessboard.squares[new_x][new_y].attacked_by[OPPONENT[:color]]
            p = @owner_chessboard.squares[new_x][new_y].chess_piece
            moves.add([new_x, new_y]) if p.nil? || p.color != self.color
          end
        end
      end
      if !@already_moved
        h = @color == Color::WHITE ? 0 : 7
        r1 = @owner_chessboard.squares[h][0].chess_piece
        r2 = @owner_chessboard.squares[h][7].chess_piece
        if r1.is_a?(Rook) && !r1.already_moved && !@owner_chessboard.squares[h][2].attacked_by[OPPONENT[:color]] && !@owner_chessboard.squares[h][1].attacked_by[OPPONENT[:color]]
          moves.add([h, 1]) if @owner_chessboard.squares[h][2].chess_piece.nil? && @owner_chessboard.squares[h][1].chess_piece.nil?
        end
        if r2.is_a?(Rook) && !r2.already_moved && !@owner_chessboard.squares[h][5].attacked_by[OPPONENT[:color]] && !@owner_chessboard.squares[h][4].attacked_by[OPPONENT[:color]]
          moves.add([h, 5]) if @owner_chessboard.squares[h][5].chess_piece.nil? && @owner_chessboard.squares[h][4].chess_piece.nil? && @owner_chessboard.squares[h][6].chess_piece.nil?
        end
      end
      return moves
    end

    def valid_attacks(cur_pos)
      moves = Set.new
      directions = [
        [-1, -1], [0, -1], 
        [1, -1], [1, 0], 
        [1, 1], [0, 1], 
        [-1, 1], [-1, 0]
      ]

      directions.each do |dx, dy|
        new_x = cur_pos[0] + dx
        new_y = cur_pos[1] + dy
        if new_x.between?(0, 7) && new_y.between?(0, 7)
          if !@owner_chessboard.squares[new_x][new_y].attacked_by[OPPONENT[:color]]
            p = @owner_chessboard.squares[new_x][new_y].chess_piece
            moves.add([new_x, new_y]) if p.nil? || p.color != self.color
          end
        end
      end
      return moves
    end


    def step_valid?(cur_pos, new_pos)
      return valid_moves(cur_pos).include?(new_pos)
    end

    def make_step(cur_pos, new_pos)
      @already_moved = true
      if new_pos[1] - cur_pos[1] == 2
        @owner_chessboard.make_step([cur_pos[0], 7], cur_pos[0], 4)
      end
      if new_pos[1] - cur_pos[1] == -2
        @owner_chessboard.make_step([cur_pos[0], 0], cur_pos[0], 2)
      end
    end

    def has_moves?(cur_pos)
      return (valid_moves(cur_pos).size > 0)
    end
  end
  class Queen < Chess_piece
    def initialize(color, owner_chessboard)
      super(color, owner_chessboard)
    end
    
    def valid_moves(cur_pos)
      moves = Set.new
      directions = [
        [ [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7] ],
        [ [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7] ],
        [ [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7] ],
        [ [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7] ],
        [ [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7] ],
        [ [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7] ],
        [ [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0] ],
        [ [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0] ]
      ]
      directions.each do |arr|
        arr.each do |dx, dy|
          new_x = cur_pos[0] + dx
          new_y = cur_pos[1] + dy
          if new_x.between?(0, 7) && new_y.between?(0, 7)
            p = @owner_chessboard.squares[new_x][new_y].chess_piece
            moves.add([new_x, new_y]) if p.nil?
            if !p.nil? 
              moves.add([new_x, new_y]) if p.color != self.color
              break
            end
          end
        end
      end
      return moves
    end

    def valid_attacks(cur_pos)
      return valid_moves(cur_pos)
    end

    def step_valid?(cur_pos, new_pos)
      return valid_moves(cur_pos).include?(new_pos)
    end

    def make_step(cur_pos, new_pos)
    end

    def has_moves?(cur_pos)
      return (valid_moves(cur_pos).size > 0)
    end
  end
  class Rook < Chess_piece
    attr_reader :already_moved
    def initialize(color, owner_chessboard)
      super(color, owner_chessboard)
      @already_moved = false
    end

    def valid_moves(cur_pos)
      moves = Set.new
      directions = [
        [ [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7] ],
        [ [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7] ],
        [ [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0] ],
        [ [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0] ]
      ]
      directions.each do |arr|
        arr.each do |dx, dy|
          new_x = cur_pos[0] + dx
          new_y = cur_pos[1] + dy
          if new_x.between?(0, 7) && new_y.between?(0, 7)
            p = @owner_chessboard.squares[new_x][new_y].chess_piece
            moves.add([new_x, new_y]) if p.nil?
            if !p.nil?
              moves.add([new_x, new_y]) if p.color != self.color
              break
            end
          end
        end
      end
      return moves
    end

    def valid_attacks(cur_pos)
      return valid_moves(cur_pos)
    end

    def step_valid?(cur_pos, new_pos)
      return valid_moves(cur_pos).include?(new_pos)
    end

    def make_step(cur_pos, new_pos)
      @already_moved = true
    end

    def has_moves?(cur_pos)
      return (valid_moves(cur_pos).size > 0)
    end
  end
  class Bishop < Chess_piece
    def initialize(color, owner_chessboard)
      super(color, owner_chessboard)
    end
    
    def valid_moves(cur_pos)
      moves = Set.new
      directions = [
        [ [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7] ],
        [ [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7] ],
        [ [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7] ],
        [ [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7] ]
      ]
      directions.each do |arr|
        arr.each do |dx, dy|
          new_x = cur_pos[0] + dx
          new_y = cur_pos[1] + dy
          if new_x.between?(0, 7) && new_y.between?(0, 7)
            p = @owner_chessboard.squares[new_x][new_y].chess_piece
            moves.add([new_x, new_y]) if p.nil?
            if !p.nil? 
              moves.add([new_x, new_y]) if p.color != self.color
              break
            end
          end
        end
      end
      return moves
    end

    def valid_attacks(cur_pos)
      return valid_moves(cur_pos)
    end

    def step_valid?(cur_pos, new_pos)
      return valid_moves(cur_pos).include?(new_pos)
    end

    def make_step(cur_pos, new_pos)
    end

    def has_moves?(cur_pos)
      return (valid_moves(cur_pos).size > 0)
    end
  end
  class Knight < Chess_piece
    def initialize(color, owner_chessboard)
      super(color, owner_chessboard)
    end
    
    def valid_moves(cur_pos) # Обращение к nil
      moves = Set.new
      directions = [
        [-1, -2], [-1, 2], 
        [-2, -1], [-2, 1], 
        [1, -2], [1, 2], 
        [2, -1], [2, 1]
      ]

      directions.each do |dx, dy|
        new_x = cur_pos[0] + dx
        new_y = cur_pos[1] + dy
        if new_x.between?(0, 7) && new_y.between?(0, 7)
          p = @owner_chessboard.squares[new_x][new_y].chess_piece
          moves.add([new_x, new_y]) if p.nil? || p.color != self.color
        end
      end
      return moves
    end

    def valid_attacks(cur_pos)  # Обращение к nil
      return valid_moves(cur_pos)
    end

    def step_valid?(cur_pos, new_pos)
      return valid_moves(cur_pos).include?(new_pos)
    end

    def make_step(cur_pos, new_pos)
    end

    def has_moves?(cur_pos)
      return (valid_moves(cur_pos).size > 0)
    end
  end
  class Pawn < Chess_piece
    def initialize(color, owner_chessboard)
      super(color, owner_chessboard)
      @already_moved = false
    end

    def valid_attacks(cur_pos)
      moves = Set.new
      h = @color == Color::WHITE ? cur_pos[0] + 1 : cur_pos[0] - 1
      if h.between?(0, 7)
        moves.add([h, cur_pos[1] - 1]) if cur_pos[1] - 1 >= 0
        moves.add([h, cur_pos[1] + 1]) if cur_pos[1] + 1 < 8
      end
      return moves
    end

    def valid_moves(cur_pos)
      moves = Set.new
      h = @color == Color::WHITE ? cur_pos[0] + 1 : cur_pos[0] - 1
      if h.between?(0, 7)
        p = @owner_chessboard.squares[h][cur_pos[1]].chess_piece
        if p.nill? then moves.add([h, cur_pos[1]]) end
          if cur_pos[1] - 1 >= 0
            p = @owner_chessboard.squares[h][cur_pos[1] - 1].chess_piece
            if p != nil and p.color != self.color then moves.add([h, cur_pos[1] - 1]) end
          end
          if cur_pos[1] + 1 < 8
            p = @owner_chessboard.squares[h][cur_pos[1] + 1].chess_piece
            if p != nil and p.color != self.color then moves.add([h, cur_pos[1] + 1]) end
          end
      end
      if @already_moved == false
        if @color == Color::WHITE then hh = cur_pos[0] + 2 else hh = cur_pos[0] - 2 end
        p = @owner_chessboard.squares[h][cur_pos[1]].chess_piece
        pp = @owner_chessboard.squares[hh][cur_pos[1]].chess_piece
        if p == nil and pp == nil then moves.add([hh, cur_pos[1]]) end
      end
      return moves
    end

    def step_valid?(cur_pos, new_pos)
      return valid_moves(cur_pos).include?(new_pos)
    end

    def make_step(cur_pos, new_pos)
      @already_moved = true
    end

    def has_moves?(cur_pos)
      return (valid_moves(cur_pos).size > 0)
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
      
      @king_position = { Color::WHITE => @squares[0][3], Color::BLACK => @squares[7][3] }
      @player_color = Color::BLACK; # Надо белых поставить
      
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
      if @king_position[OPPONENT[@player_color]].attacked_by[@player_color] == true
        if @player_color == Color::WHITE 
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
        if @king_position[@player_color].attacked_by[OPPONENT[@player_color]] == true
          if @player_color == Color::BLACK 
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
      if @squares[cur_pos[0]][cur_pos[1]].chess_piece.step_valid?(cur_pos, new_pos)
        @squares[cur_pos[0]][cur_pos[1]].chess_piece.make_step(cur_pos, new_pos)
        @squares[new_pos[0]][new_pos[1]].chess_piece = @squares[cur_pos[0]][cur_pos[1]].chess_piece
        @squares[cur_pos[0]][cur_pos[1]].chess_piece = nil
      end
      if @king_position[OPPONENT[@player_color]].attacked_by[@player_color] == true
        @position_type = Position_type::CHECK
      else
        @position_type = Position_type::ORDINARY
      end
      update()
      @player_color = OPPONENT[@player_color];
    end

  end
  class Chess
  end
end
