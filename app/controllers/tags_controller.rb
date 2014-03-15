class TagsController < ApplicationController
	def create
		t = Tag.new
		t.text = params[:text]
		t.list_id = params[:list_id]
		t.save
		redirect_to list_path(params[:list_id])
	end

	#let a logged in user delete their own tags
  	def destroy
  		t = Tag.find_by_id_and_list_id(params[:id], params[:list_id])
  		t.destroy
  		redirect_to list_path(params[:list_id])
  	end
end
