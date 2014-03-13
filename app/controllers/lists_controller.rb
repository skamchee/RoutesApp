class ListsController < ApplicationController

	#show the lists the user has ownership of 
	def index
		u = User.find_by(:id => session[:user_id]) 
		if u 
			@lists = u.lists
		end

		respond_to do |format|
			format.html do
				render 'index'
			end
			format.json do
				render :json => @lists, :except => [:id, :user_id]
			end
		end
	end

	#show the locations at that list
	def show
		@list = List.find_by(id: params[:id])
		@locations = Location.where(list_id: params[:id])
		session[:list_id]= params[:id]
		cookies[:list_id]= params[:id]

		respond_to do |format|
			format.html do
				render 'show'
			end
			format.json do
				render :json => @locations, :except => [:id, :list_id]
			end
		end
	end

	def create
		l = List.new
		l.name = params[:name]
		l.description = params[:description]
		l.user_id = session[:user_id]
		l.save
		redirect_to list_path(l.id)
	end

	def edit
		if session[:user_id]==List.find_by(id: params[:id]).user_id
			@list = List.find_by(:id => params[:id])
		else
			redirect_to root_url
		end
	end

	def update
		l = List.find_by(:id => params[:id])
		l.name = params[:name]
		l.description = params[:description]
		l.save
		redirect_to lists_url
	end

	def destroy
		l = List.find_by(:id => params[:id])
		l.destroy
		redirect_to lists_url
	end
end
