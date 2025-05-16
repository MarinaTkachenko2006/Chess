class ChessController < ApplicationController
  require_relative '../../lib/chess'
  skip_before_action :verify_authenticity_token, only: [:newGame,:makeMove]
  def initialize
    super
  end

  def availableMoves
    position = params[:position]
    x,y = position.split('-').map(&:to_i)
    game = ChessGame.instance
    
    av_mvs_arr = []
    figure = game.squares[x][y].chess_piece

    if (!figure.nil?)
      av_mvs_arr=figure.valid_moves([x,y]).map{|xy|"#{xy[0]}-#{xy[1]}"}
    end
    render json:av_mvs_arr
  end

  def makeMove
    from,to = params[:from],params[:to]
    x0,y0 = from.split('-').map(&:to_i)
    x1,y1 = to.split('-').map(&:to_i)
    game = ChessGame.instance
    
    figure = game.squares[x0][y0].chess_piece
    old,new = [],[]

    if (!figure.nil?)
      old,new = game.make_step([x0,y0],[x1,y1])
    end
    render json:{old_coordinates:old,new_coordinates:new}
  end

  def newGame
    ChessGame.reset
    render json:{message:"game succesfully restarted"},status: :ok
  end



end