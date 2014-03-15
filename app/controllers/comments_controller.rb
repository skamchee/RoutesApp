class CommentsController < ApplicationController
	def create
		c = Comment.new
		c.text = params[:text]
		c.user_id = session[:user_id]
		c.location_id = params[:location_id]
		c.save
		redirect_to location_path(params[:location_id])
	end
end
