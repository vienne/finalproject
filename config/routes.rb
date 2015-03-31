Rails.application.routes.draw do
	root to: 'venues#index'

	get '/venues', to: "venues#index"

  get '/venues/near', to: "venues#near", as: :venues_near
 
end
