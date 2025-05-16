class ChessController < ApplicationController
  require_relative '../../lib/chess'
  
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


end