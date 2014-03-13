#resource containing a user's favorited lists

class FavoritesController < ApplicationController

	#controller filter to force use to login in order access any pages that update the models
	before_action :require_login
	def require_login
		if !session[:user_id].present?
			redirect_to root_url
		end
	end

	#let a logged in user favorite another users list of locations
	def new
		f = Favorite.new
		f.user_id = session[:user_id]
		f.list_id = params[:list_id]
		f.save
		l = List.find_by(:id => params[:list_id])
		u = User.find_by(:id => l.user_id)
		redirect_to user_path(u.name)
	end

	#show the logged in user's favorites
	def index
		@lists = Array.new
	    @user = User.find_by(:id => session[:user_id]) 
	    if @user 
	      @favorites = @user.favorites
	      if @favorites
	      	@favorites.each do |f|
	      		@lists.append(List.find_by(:id => f.list_id))
	      	end
	      end
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

  	#let a logged in user unfavorite another user's list
  	def destroy
  		f = Favorite.find_by_user_id_and_list_id(session[:user_id], params[:id])
  		f.destroy
  		redirect_to favorites_url
  	end
end
