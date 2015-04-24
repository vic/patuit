class PatuitController < ApplicationController

  skip_before_action :verify_authenticity_token

  def friend_info
    render json: User.friendship(params[:nickname], params[:friend])
  end

  def tweet
    nickname = params[:nickname]
    message = params[:message]

    user = User.find_or_create_by(nickname: nickname)
    tweet = Tweet.new(message: message, created_at: Time.now.to_i, author: nickname)
    user.tweets << tweet

    render json: tweet, status: :created    
  end

  def timeline
    render json: Tweet.timeline(params[:nickname])
  end

  def follow
    user = User.find_or_create_by(nickname: params[:nickname])
    friend = User.find_or_create_by(nickname: params[:friend])
    user.friends << friend
    render json: { }
  end

  def unfollow
    user = User.find_by(nickname: params[:nickname])
    friend = User.find_by(nickname: params[:friend])
    user.friends.delete(friend)
    render json: { }
  end

end