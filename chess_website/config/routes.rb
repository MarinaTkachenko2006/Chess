Rails.application.routes.draw do
  get "moves", to:"chess#availableMoves"
  #post "restart", to:"chess#newGame"
  post "move", to:"chess#makeMove"
  post 'create', to: 'chess#newGame'
end
