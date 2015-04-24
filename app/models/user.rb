class User 
  include Neo4j::ActiveNode
 
  property :nickname
  has_many :out, :friends, :type => :follows, model_class: User
  has_many :out, :tweets, :type => :tweeted
  has_many :out, :favorites, :type => :favorited, model_class: Tweet
  has_many :out, :retweets, :type => :retweeted, model_class: Tweet

  def followers_count
    Neo4j::Session.query.
    match('(User {nickname: {nickname}})<-[:follows]-(f:User)').
    return('COUNT(f) as followers').
    params(nickname: nickname).first.followers
  end


  def self.friendship(my_nickname, friend_nickname)
    user = User.find_by(nickname: my_nickname)
    friend = User.find_by(nickname: friend_nickname)

    user_info = user && user.as_json['user'] || {nickname: my_nickname}
    friend_info = friend && friend.as_json['user'] || {nickname: friend_nickname}

    user_info.merge!({
      followed: friend && user && friend.friends.include?(user),
      followers: user && user.followers_count || 0,
      tweets: user && user.tweets.count || 0
    })

    friend_info.merge!({
      followed: friend && user && user.friends.include?(friend),
      followers: friend && friend.followers_count || 0,
      tweets: friend && friend.tweets.count || 0
    })

    {user: user_info, friend: friend_info}
  end

end
