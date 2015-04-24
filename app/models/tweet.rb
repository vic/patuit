class Tweet 
  include Neo4j::ActiveNode

  property :message  
end
