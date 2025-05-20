Rails.application.routes.draw do
  get "moves", to:"chess#availableMoves"
  post "move", to:"chess#makeMove"
  post 'start', to: 'chess#newGame'
end
