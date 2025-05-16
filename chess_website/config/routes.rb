Rails.application.routes.draw do
  get "moves",to:"chess#availableMoves"
  post "restart",to:"chess#newGame"
  
end
