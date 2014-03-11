class UsersController < ApplicationController

#show other users lists
  def show
    @user = User.find_by(:name => params[:id]) 
    if @user 
      @lists = @user.lists
    end

    respond_to do |format|
      format.html do
        render 'show'
      end
      format.json do
        render :json => @lists, :except => [:id, :user_id]
      end
    end
  end


  def create
    user = User.new
    user.name = params[:name]
    user.email = params[:email]
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    

    user.save
    if !user.errors.full_messages.blank?
      session[:errors] = user.errors.full_messages
      redirect_to new_user_url
    else 
      session[:user_id] = user.id  #sign in the new user
      redirect_to sessions_url  #send the user to session#index
    end

    
  end
end
