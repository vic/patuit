Rails.application.routes.draw do

  root 'patuit#index'

  controller :patuit do
    post :tweet, :follow, :unfollow, :retweet
    get  :timeline, :friend_info
  end
  
end
