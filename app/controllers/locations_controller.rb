class LocationsController < ApplicationController

	#controller filter to force use to login in order access any pages that update the models
	before_action :require_login, :except => [:show]
	def require_login
		if !session[:user_id].present?
			redirect_to root_url
		end
	end

	def show
		@location = Location.find_by(id: params[:id])
		@comments = @location.comments.order("id desc")
	end

	def create
		l = Location.new
		l.list_id = session[:list_id]
		l.name = params[:name]
		l.lat = params[:lat]
		l.lng = params[:lng]
		l.address = params[:autocomplete]
		l.description = params[:description]
		l.save

		if !l.errors.full_messages.blank?
			session[:errors] = l.errors.full_messages
			redirect_to new_location_url#"/lists/#{params[:list_id]}"
		else 
			redirect_to list_url(id: session[:list_id])
		end
	end

	def edit
		if session[:user_id]==List.find_by(id: session[:list_id]).user_id
			@location = Location.find_by(id: params[:id])
		else
			redirect_to root_url
		end
	end

	def update
		l = Location.find_by(id: params[:id])
		l.name = params[:name]
		#if lat and lng are blank, use the previous value.
		#why? because the lat and lng will be blank since not geocoded by google js api if the address field was not updated
		if !params[:lat].blank?
			l.lat = params[:lat]
		end
		if !params[:lng].blank?
			l.lng = params[:lng]
		end
		l.address = params[:autocomplete]
		l.description = params[:description]
		l.save

		if !l.errors.full_messages.blank?
			session[:errors] = l.errors.full_messages
			redirect_to edit_location_url(id: l.id)
		else 
			redirect_to list_url(id: session[:list_id])
		end
	end


	def destroy
		l = Location.find_by(id: params[:id]) #params[:id] contains the Locations id
		list_id= l.list_id
		l.destroy
		redirect_to list_path(list_id)
	end

end
