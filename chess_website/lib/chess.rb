# frozen_string_literal: true

# require_relative "Chess/version"

module Chess
  class Error < StandardError; end

  # Перечисление цветов шахматных фигур
  module Color
    WHITE = 0
    BLACK = 1
  end

  # Hash-table оппонентов
  OPPONENT = {
    Color::WHITE => Color::BLACK,
    Color::BLACK => Color::WHITE
  }

  # Базовый класс шахматной фигуры
  class Chess_piece
    attr_reader :color
    attr_accessor :already_moved

    def initialize(color, owner_chessboard)
      @color = color
      @owner_chessboard = owner_chessboard
      @already_moved = false
    end

    # Возвращает допустимые ходы
    def valid_moves(cur_pos)
      return [] # TODO
    end

    # Совершает ход
    def make_step(cur_pos, new_pos, old_coords, new_coords)
      return [] # TODO
    end

    # Проверяет кооректность хода
    def step_valid?(cur_pos, new_pos)
      return true # TODO
    end

    # Проверяет, есть у фигуры допустимые ходы
    def has_moves?
      return true
    end
  end

  # Класс Короля
  class King < Chess_piece

    def valid_moves(cur_pos)
      moves = Set.new
      directions = [
        [-1, -1], [0, -1], 
        [1, -1], [1, 0], 
        [1, 1], [0, 1], 
        [-1, 1], [-1, 0]
      ]

      # Простые ходы
      directions.each do |dx, dy|
        new_x = cur_pos[0] + dx
        new_y = cur_pos[1] + dy
        next unless @owner_chessboard.in_bounds?(new_x, new_y)

        if @owner_chessboard.square_empty?(new_x, new_y) || @owner_chessboard.piece_at(new_x, new_y).color != @color
          moves.add([new_x, new_y])
        end
      end

      # Рокировка
      if !@already_moved
        h = @color == Color::WHITE ? 7 : 0
        r1 = @owner_chessboard.piece_at(h, 0)
        r2 = @owner_chessboard.piece_at(h, 7)

        if r1.is_a?(Rook) && !r1.already_moved
          moves.add([h, 2]) if @owner_chessboard.square_empty?(h, 2) && @owner_chessboard.square_empty?(h, 3) && @owner_chessboard.square_empty?(h, 1) # Можно использовать all
        end
        if r2.is_a?(Rook) && !r2.already_moved
          moves.add([h, 6]) if @owner_chessboard.square_empty?(h, 5) && @owner_chessboard.square_empty?(h, 6) # Можно использовать all
        end
      end

      return moves
    end

    def step_valid?(cur_pos, new_pos)
      return valid_moves(cur_pos).include?(new_pos)
    end

    def make_step(cur_pos, new_pos, old_coords, new_coords)
      @already_moved = true
      @owner_chessboard.last_double_moved_pawn = nil
      
      # Рокировка (сдвиг ладьи)
      if new_pos[1] - cur_pos[1] == 2
        @owner_chessboard.squares[cur_pos[0]][5].chess_piece = @owner_chessboard.squares[cur_pos[0]][7].chess_piece
        @owner_chessboard.squares[cur_pos[0]][7].chess_piece = nil
        old_coords << [cur_pos[0], 7]
        new_coords << [cur_pos[0], 5]
      end
      
      if new_pos[1] - cur_pos[1] == -2
        @owner_chessboard.squares[cur_pos[0]][2].chess_piece = @owner_chessboard.squares[cur_pos[0]][0].chess_piece
        @owner_chessboard.squares[cur_pos[0]][0].chess_piece = nil
        old_coords << [cur_pos[0], 0]
        new_coords << [cur_pos[0], 3]
      end

    end


    def has_moves?(cur_pos)
      return valid_moves(cur_pos).size > 0
    end
  end

  # Класс Королевы
  class Queen < Chess_piece

    # Возвращает допустимые ходы
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

      # МАРИНА, УМНИЧКА

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

    def step_valid?(cur_pos, new_pos)
      return valid_moves(cur_pos).include?(new_pos)
    end

    def make_step(cur_pos, new_pos, old_coords, new_coords)
      @already_moved = true
      @owner_chessboard.last_double_moved_pawn = nil
    end

    def has_moves?(cur_pos)
      return valid_moves(cur_pos).size > 0
    end
  end

  # Класс Ладьи
  class Rook < Chess_piece

    # Возвращает допустимые ходы
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

    def step_valid?(cur_pos, new_pos)
      return valid_moves(cur_pos).include?(new_pos)
    end

    def make_step(cur_pos, new_pos, old_coords, new_coords)
      @already_moved = true
      @owner_chessboard.last_double_moved_pawn = nil
    end

    def has_moves?(cur_pos)
      return valid_moves(cur_pos).size > 0
    end
  end

  # Класс Слона
  class Bishop < Chess_piece
    
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

    def step_valid?(cur_pos, new_pos)
      return valid_moves(cur_pos).include?(new_pos)
    end

    def make_step(cur_pos, new_pos, old_coords, new_coords)
      @already_moved = true
      @owner_chessboard.last_double_moved_pawn = nil
    end

    def has_moves?(cur_pos)
      return valid_moves(cur_pos).size > 0
    end
  end

  # Класс Коня
  class Knight < Chess_piece

    def valid_moves(cur_pos)
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

    def step_valid?(cur_pos, new_pos)
      return valid_moves(cur_pos).include?(new_pos)
    end

    def make_step(cur_pos, new_pos, old_coords, new_coords)
      @already_moved = true
      @owner_chessboard.last_double_moved_pawn = nil
    end

    def has_moves?(cur_pos)
      return valid_moves(cur_pos).size > 0
    end
  end

  # Класс Пешки
  class Pawn < Chess_piece
    def valid_moves(cur_pos)
      moves = Set.new
      h = @color == Color::WHITE ? cur_pos[0] - 1 : cur_pos[0] + 1
      if h.between?(0, 7)
        if @owner_chessboard.square_empty?(h, cur_pos[1]) then moves.add([h, cur_pos[1]]) end
          if cur_pos[1] - 1 >= 0
            p = @owner_chessboard.piece_at(h, cur_pos[1] - 1)
            if !p.nil? and p.color != @color then moves.add([h, cur_pos[1] - 1]) 
            else 
              pp = @owner_chessboard.piece_at(cur_pos[0], cur_pos[1] - 1)
              if !pp.nil? && pp.color != @color
                if @owner_chessboard.last_double_moved_pawn == [cur_pos[0], cur_pos[1] - 1] # Захват на проходе
                  moves.add([h, cur_pos[1] - 1])
                end
              end
            end
          end
          if cur_pos[1] + 1 < 8
            p = @owner_chessboard.piece_at(h, cur_pos[1] + 1)
            if !p.nil? and p.color != @color then moves.add([h, cur_pos[1] + 1])
            else 
              pp = @owner_chessboard.piece_at(cur_pos[0], cur_pos[1] + 1)
              if p.nil? && !pp.nil? && pp.color != self.color
                if @owner_chessboard.last_double_moved_pawn == [cur_pos[0], cur_pos[1] + 1] # Захват на проходе
                  moves.add([h, cur_pos[1] + 1])
                end
              end
            end
          end
      end

      # Двойной шаг
      if !@already_moved
        if @color == Color::WHITE then hh = cur_pos[0] - 2 else hh = cur_pos[0] + 2 end
            p = @owner_chessboard.piece_at(h, cur_pos[1])
            pp = @owner_chessboard.piece_at(hh, cur_pos[1])

            if p.nil? and pp.nil? then moves.add([hh, cur_pos[1]]) end
      end

      return moves
    end

    def step_valid?(cur_pos, new_pos)
      return valid_moves(cur_pos).include?(new_pos)
    end

    def make_step(cur_pos, new_pos, old_coords, new_coords)
      @already_moved = true

      if (new_pos[0]-cur_pos[0]).abs == 2
        @owner_chessboard.last_double_moved_pawn = [new_pos[0], new_pos[1]]
      else
        @owner_chessboard.last_double_moved_pawn = nil
      end

      # Захват на проходе
      if (new_pos[1]-cur_pos[1]).abs == 1 && @owner_chessboard.square_empty?(new_pos[0], new_pos[1])
        @owner_chessboard.squares[cur_pos[0]][new_pos[1]].chess_piece = nil
        old_coords << [cur_pos[0], new_pos[1]]
        new_coords << [nil, nil]
      end
    end

    def has_moves?(cur_pos)
      return valid_moves(cur_pos).size > 0
    end
  end

  # Класс квадрата шахматной доски
  class Square
    attr_accessor :chess_piece

    def initialize(chess_piece = nil)
      @chess_piece = chess_piece
    end

  end

  # Класс шахматной доски
  class Chessboard
    attr_accessor :squares, :last_double_moved_pawn
    
    attr_reader :king_position

    def initialize()
      # Инициализация шахматной сетки
      @last_double_moved_pawn = nil
      @squares = Array.new(8) { Array.new(8) { Square.new } }

      # Инициализация белых фигур

      @squares[7][0].chess_piece = Rook.new(Color::WHITE, self)
      @squares[7][1].chess_piece = Knight.new(Color::WHITE, self)
      @squares[7][2].chess_piece = Bishop.new(Color::WHITE, self)
      @squares[7][4].chess_piece = King.new(Color::WHITE, self)
      @squares[7][3].chess_piece = Queen.new(Color::WHITE, self)
      @squares[7][5].chess_piece = Bishop.new(Color::WHITE, self)
      @squares[7][6].chess_piece = Knight.new(Color::WHITE, self)
      @squares[7][7].chess_piece = Rook.new(Color::WHITE, self)

      for piece in @squares[6]
        piece.chess_piece = Pawn.new(Color::WHITE, self)
      end

      # Инициализация чёрных фигур

      @squares[0][0].chess_piece = Rook.new(Color::BLACK, self)
      @squares[0][1].chess_piece = Knight.new(Color::BLACK, self)
      @squares[0][2].chess_piece = Bishop.new(Color::BLACK, self)
      @squares[0][4].chess_piece = King.new(Color::BLACK, self)
      @squares[0][3].chess_piece = Queen.new(Color::BLACK, self)
      @squares[0][5].chess_piece = Bishop.new(Color::BLACK, self)
      @squares[0][6].chess_piece = Knight.new(Color::BLACK, self)
      @squares[0][7].chess_piece = Rook.new(Color::BLACK, self)
      
      for piece in @squares[1]
        piece.chess_piece = Pawn.new(Color::BLACK, self)
      end
      
      @king_position = { Color::WHITE => [7, 4], Color::BLACK => [0, 4] }
    end

    def make_step(cur_pos, new_pos)

      old_coordinates = []
      new_coordinates = []

      piece = @squares[cur_pos[0]][cur_pos[1]].chess_piece

      # Передаём эти массивы в методы make_step фигур
      if @squares[cur_pos[0]][cur_pos[1]].chess_piece.step_valid?(cur_pos, new_pos)
        old_coordinates << [cur_pos[0], cur_pos[1]]
        new_coordinates << [new_pos[0], new_pos[1]]
        
        @squares[cur_pos[0]][cur_pos[1]].chess_piece.make_step(cur_pos, new_pos, old_coordinates, new_coordinates) # make_step может менять другие фигуры, а не только рассматриваемую
        
        @squares[new_pos[0]][new_pos[1]].chess_piece = @squares[cur_pos[0]][cur_pos[1]].chess_piece
        @squares[cur_pos[0]][cur_pos[1]].chess_piece = nil

        # Это лишнее
        #old_coordinates << [new_pos[0], new_pos[1]]
        #new_coordinates << [nil, nil]

        #if  @squares[new_pos[0]][new_pos[1]].chess_piece.is_a?(King) # Обновление позиции короля
        #  @king_position[@player_color] = [new_pos[0], new_pos[1]]
        #end

        if  @squares[new_pos[0]][new_pos[1]].chess_piece.is_a?(Pawn)
          h = @squares[new_pos[0]][new_pos[1]].chess_piece.color == Color::WHITE ? 0 : 7
          if new_pos[0] == h
            @squares[new_pos[0]][new_pos[1]].chess_piece = Queen.new(h == 0 ? Color::WHITE : Color::BLACK , self)
          end
        end

        status = if checkmate?(OPPONENT[piece.color])
            "мат"
          elsif check?(OPPONENT[piece.color])
            "шах"
          elsif stalemate?(OPPONENT[piece.color])
            "пат"
          else
            "продолжение"
          end

        return old_coordinates, new_coordinates, status
      end
    end

    def make_unsafe_step(cur_pos, new_pos)
      
      old_coordinates = []
      new_coordinates = []

      piece = @squares[cur_pos[0]][cur_pos[1]].chess_piece

      # Передаём эти массивы в методы make_step фигур
      if @squares[cur_pos[0]][cur_pos[1]].chess_piece.step_valid?(cur_pos, new_pos)
        old_coordinates << [cur_pos[0], cur_pos[1]]
        new_coordinates << [new_pos[0], new_pos[1]]
        
        @squares[cur_pos[0]][cur_pos[1]].chess_piece.make_step(cur_pos, new_pos, old_coordinates, new_coordinates) # make_step может менять другие фигуры, а не только рассматриваемую
        
        @squares[new_pos[0]][new_pos[1]].chess_piece = @squares[cur_pos[0]][cur_pos[1]].chess_piece
        @squares[cur_pos[0]][cur_pos[1]].chess_piece = nil

        # Это лишнее
        #old_coordinates << [new_pos[0], new_pos[1]]
        #new_coordinates << [nil, nil]

        if  @squares[new_pos[0]][new_pos[1]].chess_piece.is_a?(King) # Обновление позиции короля
          @king_position[@squares[new_pos[0]][new_pos[1]].chess_piece.color] = [new_pos[0], new_pos[1]]
        end

        if  @squares[new_pos[0]][new_pos[1]].chess_piece.is_a?(Pawn)
          h = @color == Color::WHITE ? 0 : 7
          if new_pos[0] == h
            @squares[new_pos[0]][new_pos[1]].chess_piece = Queen.new(h == 7 ? Color::WHITE : Color::BLACK , self)
          end
        end

        return old_coordinates, new_coordinates
      end
    end

    # Проверяет, является ли указанная клетка пустой
    def square_empty?(row, col)
      return false unless in_bounds?(row, col)
      return @squares[row][col].chess_piece.nil?
    end 

    # Проверяет, находится ли данная позиция в границах шахматной доски
    def in_bounds?(row, col)
      return row.between?(0,7) && col.between?(0,7)
    end

    # Возвращает шахматную фигуру на данной позиции
    def piece_at(row, col)
      return nil unless in_bounds?(row,col)
      return @squares[row][col].chess_piece
    end

    # Проверяет, поставлен ли шах
    def check?(color)
      puts "check?"

      king_position = find_king_position(color)
      
      return false unless king_position
      
      return square_under_attack?(king_position[0], king_position[1], OPPONENT[color])
    end

    def find_king_position(color)
      (0..7).each do |r|
        (0..7).each do |c|
          piece = @squares[r][c].chess_piece
          if piece && piece.is_a?(King) && piece.color == color
            return [r,c]
          end
        end
      end
      return nil
    end

    # Проверяет, поставлен ли шах и мат
    def checkmate?(color)
      puts "checkmate?"

      return false unless check?(color) # Если король не под шахом

      # Проверяем все фигуры данного цвета и их возможные ходы
      @squares.each_with_index do |row, r|
        row.each_with_index do |square, c|
          piece = square.chess_piece
          next if piece.nil? || piece.color != color

          valid_moves = piece.valid_moves([r, c])

          valid_moves.each do |move|
            board_copy = clone_board
            result = board_copy.make_unsafe_step([r, c], [move[0], move[1]])

            # Если после этого хода король не под шахом — это не мат
            unless board_copy.check?(color)
              return false
            end
          end
        end
      end

      # Если ни один ход не спасает — мат
      return true
    end

    # Клонирование доски
    def clone_board
      puts "deep_clone_board"
      
      clone_board = Chess::Chessboard.new
      clone_board.squares = Array.new(8) { Array.new(8) {Square.new} }
      @squares.each_with_index do |row, r|
        row.each_with_index do |square, c|
          piece = square.chess_piece

          if piece.nil?
            clone_board.squares[r][c].chess_piece = nil
          else
            clone_piece = piece.class.new(piece.color, clone_board)
            clone_piece.already_moved = piece.already_moved
            clone_board.squares[r][c].chess_piece = clone_piece
          end
        end
      end
      clone_board.last_double_moved_pawn = @last_double_moved_pawn ? [*@last_double_moved_pawn] : nil

      return clone_board
    end

    # Проверят, поставлен ли пат
    def stalemate?(color)
      puts "stalemate?"

      # Если король не под шахом, но у игрока нет допустимых ходов — пат
      return false if check?(color)

      @squares.each_with_index do |row, r|
        row.each_with_index do |square, c|
          piece = square.chess_piece
          next if piece.nil? || piece.color != color

          valid_moves = piece.valid_moves([r, c])
          valid_moves.each do |move|
            board_copy = clone_board
            result = board_copy.make_unsafe_step([r, c], [move[0], move[1]])
            unless board_copy.check?(color)
              return false  # Есть хотя бы один допустимый ход — не пат
            end
          end
        end
      end

      # Нет допустимых ходов и король не под шахом — пат
      return true
    end

    def square_under_attack?(row, col, attacker_color=nil)
      puts "square_under_attack?"
      attacker_color ||= OPPONENT[@squares[row][col].chess_piece.try(:color)]
      
      (0..7).each do |r|
        (0..7).each do |c|
          piece = @squares[r][c].chess_piece
          next unless !piece.nil? && piece.color == attacker_color
          
          valid_moves = piece.valid_moves([r, c])
          
          return true if valid_moves.include?([row,col])
        end
      end
      
      return false
    end

  end

end
