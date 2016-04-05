get '/airports' do 
	@airports = Airport.all
	erb :'airports/index'
end

get '/airports/search' do 
	# lists the airports that match the query
	if params[:q].present?
		@airports = Airport.where("name ILIKE ? OR code ILIKE ? OR country ILIKE ? OR city ILIKE ?",
			"%#{params[:q]}%",
			"%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%").limit(10)
	else
		@airports = Airport.limit(10)
	end
	json @airports
end

get '/airports/:id' do 
	@airport = Airport.find(params[:id])
	erb :'airports/show'
end

