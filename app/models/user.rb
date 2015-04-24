class User 
  include Neo4j::ActiveNode
 
  property :nickname
  has_many :out, :friends, :type => :follows, model_class: User
  has_many :out, :tweets, :type => :tweeted
  has_many :out, :favorites, :type => :favorited, model_class: Tweet
  has_many :out, :retweets, :type => :retweeted, model_class: Tweet

end
