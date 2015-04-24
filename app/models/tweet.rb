class Tweet 
  include Neo4j::ActiveNode

  property :message
  property :author
  property :created_at, type: Integer

  after_create :notify_followers

  def self.timeline(nickname)
    match = <<-EOF
      (u:User {nickname: {nickname}})-[:tweeted]->(t:Tweet)
      RETURN t as tweet, t.created_at as d
      ORDER BY d DESC LIMIT 10
      UNION MATCH
      (u:User {nickname: {nickname}})-[:follows]->(User)-[:tweeted]->(t:Tweet)
      RETURN t as tweet, t.created_at as d
      ORDER BY d DESC LIMIT 10
      UNION MATCH 
      (u:User {nickname: {nickname}})-[:follows]->(User)-[:retweeted]->(t:Tweet)<-[:tweeted]-(x:User)
      WHERE NOT (u)-[:follows]->(x)
      RETURN t as tweet, t.created_at as d
      ORDER BY d DESC LIMIT 10
    EOF
    Neo4j::Session.query.match(match).params(nickname: nickname)
    .map(&:tweet).sort_by(&:created_at).reverse.take(10)
  end


  def followers_to_notify
    match = <<-EOF
      (t:Tweet {uuid: {uuid}})<-[:tweeted]-(a:User)<-[:follows]-(f:User)
      RETURN f.nickname as nickname
      UNION MATCH
      (a:User)-[:tweeted]->(t:Tweet {uuid: {uuid}})<-[:retweeted]-(r:User)<-[:follows]-(f:User)
      WHERE NOT (f)-[:follows]->(a)
      RETURN f.nickname as nickname
    EOF
    [author] + Neo4j::Session.query.match(match).params(uuid: uuid).map(&:nickname)
  end

  def notify_followers
    followers_to_notify.each { |nickname| notify_follower(nickname) }
  end

  def notify_follower(nickname)
    db = CouchRest.database("http://localhost:5984/patuit")
    doc = db.get(nickname) rescue nil
    if doc
      tweets = doc.to_hash['tweets']
      tweets.unshift self.as_json
      doc['tweets'] = tweets
      doc.save
    else
      json = { '_id' => nickname, 'tweets' => [self.as_json] }
      db.save_doc(json)
    end
  end


end
