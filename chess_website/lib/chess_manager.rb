class ChessManager
  include Singleton
  
  def initialize
    @games = {} # хэш: id => Chessboard
  end
  
  def create_game(id = nil)
    id ||= generate_unique_id

    if @games.key?(id)
      raise "Игра с таким id уже существует"
    end

    @games[id] = Chess::Chessboard.new(id)
    return id
  end

  def get_game(id)
    game = @games[id]
    raise "Игра с id #{id} не найдена" unless game
    return game
  end

  def remove_game(id)
    @games.delete(id)
  end

  private

  def generate_unique_id
    loop do
      new_id = SecureRandom.uuid
      return new_id unless @games.key?(new_id)
    end
  end
end
