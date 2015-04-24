Rails.application.routes.draw do

  root 'patuit#index'

  controller :patuit do
    post :tweet, :follow, :unfollow
    get  :timeline
  end
  
end
