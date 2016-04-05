get '/users/new' do 
	erb :'users/new'
end

post '/users' do 
	@user = User.create(email: params[:email], password: params[:password])
	if @user.valid?
		session[:user_id] = @user.id
		redirect '/'
	else
		@errors = @user.errors.full_messages
		erb :'/users/new'
	end
end

get '/users/:id' do
	if logged_in?  
		@user = User.find(session[:user_id])
		@user_items = @user.items
		@user_bids = @user.bids
		@items = Item.all
		erb :'users/show'
	else
		redirect '/sessions/new'
	end
end