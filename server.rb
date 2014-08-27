require 'sinatra'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname:'slacker')
    yield(connection)
  ensure
    connection.close
  end
end



get '/slackernews' do
  erb :index
end

get '/slackernews/new' do
  erb :new
end

get '/slackernews/articles' do
  sql = 'SELECT * FROM articles'

  db_connection do |conn|
    @articles = conn.exec(sql)
  end
  erb :articles
end


post '/slackernews/new' do
  title = params['title']
  url = params['url']
  des = params['content']

  if title=nil || url=nil || des = nil

  insert = 'INSERT INTO articles(title, url, description)VALUES(
    $1, $2, $3)'

  db_connection do |conn|
    conn.exec_params(insert, [title,url,des])
  end

  redirect'/slackernews/new'
end



set :views, File.dirname(__FILE__) + '/views'
set :public_folder, File.dirname(__FILE__) + '/public'
