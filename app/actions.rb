
helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end
  
  def logged_in?
    current_user
  end
end

before '/posts/new' do
  # redirect to '/login' unless logged_in?
  
  halt(401, erb(:error_401)) unless logged_in?
  
  # if !logged_in?
  #   redirect to '/login'
  # end
end


get '/' do
  @posts = Post.order(created_at: :desc)
  user =  User.find_by(id: session[:user_id])
  erb(:index)
end

get '/signup' do
  @user = User.new
  erb :signup
end


post '/signup' do
  #extracting data from the form aka params
  email      = params[:email]
  avatar_url = params[:avatar_url]
  username   = params[:username]
  password   = params[:password]

  @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })

  if @user.save
    redirect to ('/login')
  else
    erb(:signup)
  end
end

get '/login' do 
  erb :login
end

post '/login' do
  username = params[:username]
  password = params[:password]

  user = User.find_by(username: username)  

  if user && user.password == password
    session[:user_id] = user.id
    redirect to('/')
  else
    @error_message = "Login failed."
    erb(:login)
  end
end

get '/new' do 
  erb :new
end


get '/posts/new' do
  erb(:"posts/new")
end

post '/posts' do
  photo_url = params[:photo_url]

  @post = Post.new({ photo_url: photo_url, user_id: current_user.id })

  if @post.save
    redirect(to('/'))
  else
    erb (:"posts/new")
  end
end

get '/logout' do
  session[:user_id] = nil
  erb :logout
end

get '/posts/new' do
  @post = Post.new
  erb (:"posts/new")
end

get '/posts/:id' do
  @post = Post.find(params[:id])
  erb(:'posts/show')
end

post '/likes' do 
  post_id = params[:post_id]
  
  like = Like.new({ post_id: post_id, user_id: current_user.id })
  like.save

  redirect(back)
end

delete '/likes/:id' do
  like = Like.find(params[:id])
  like.destroy
  redirect(back)
end

