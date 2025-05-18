class ChessController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:makeMove]
  require_relative '../../lib/chess'

  def availableMoves
    position = params[:position]
    x,y = position.split('-').map(&:to_i)
    game = ChessGame.instance
    
    av_mvs_arr = []
    figure = game.piece_at(x, y)

    if (!figure.nil?)
      av_mvs_arr=figure.valid_moves([x, y]).map{|xy|"#{xy[0]}-#{xy[1]}"}
    end
    render json:av_mvs_arr
  end

  def makeMove
    from,to = params[:from],params[:to]
    x0,y0 = from.split('-').map(&:to_i)
    x1,y1 = to.split('-').map(&:to_i)
    game = ChessGame.instance
    
    figure = game.piece_at(x0, y0)
    old, new = [],[]

    if (!figure.nil?)
      old, new, status = game.make_step([x0,y0],[x1,y1])
    end
    render json:{old_coordinates:old,new_coordinates:new, status: status}
  end
end

class ChessGame
  require_relative '../../lib/chess'
  @instance = Chess::Chessboard.new

  def self.instance
    @instance
  end

  def self.reset
    @instance = Chess::ChessBoard.new
  end
end