Rails.application.routes.draw do
  get "moves",to:"chess#availableMoves"
end
