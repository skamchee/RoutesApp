class FavoritesController < ApplicationController
	def new
		if !session[:user_id].blank?
			f = Favorite.new
			f.user_id = session[:user_id]
			f.list_id = params[:list_id]
			f.save
			l = List.find_by(:id => params[:list_id])
			u = User.find_by(:id => l.user_id)
			redirect_to user_path(u.name)
		end
	end


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
end
