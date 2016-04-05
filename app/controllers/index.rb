get '/' do 
	@no_nav = true
	erb :index
end