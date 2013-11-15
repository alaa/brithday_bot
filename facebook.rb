require 'koala'

class Myprofile
  def oauth_access_token
    "FB OAuth Token"
  end

  def graph
    Koala::Facebook::API.new(oauth_access_token)
  end

  def info
    graph.get_object("me")
  end

  def friends
    graph.get_connections("me", "friends")
  end

  def write(message)
    graph.put_connections("me", "feed", :message => message)
  end

  def rest
    Koala::Facebook::API.new(oauth_access_token)
  end

  def statuses
    rest = self.rest
    yesterday = Time.new(2013, 11, 13).to_i
    query = "SELECT post_id, message FROM stream WHERE source_id=me() AND comments.count == 0 AND created_time > #{yesterday} Limit 100"
    rest.fql_query(query)
  end

  def comment_on_statuses
    posts = self.statuses
    posts.each { |post|
      puts "Commenting on my post, #{post['post_id']}"
      puts graph.put_comment(post['post_id'],"Thank you for your nice wish :), 'This is an automated response.'") 
    }
  end
end

myprofile = Myprofile.new
myprofile.comment_on_statuses
