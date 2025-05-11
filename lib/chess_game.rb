class ChessGame
  # Паттерн Singleton
  @instance = Chess::Chessboard.new

  def self.instance
    @instance
  end

  def self.reset
    @instance = Chess::Chessboard.new
  end
end
