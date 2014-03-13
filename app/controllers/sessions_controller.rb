class SessionsController < ApplicationController

  def index
    #Welcome the user 
  end

  def destroy
    reset_session
    redirect_to new_session_url, notice: "Goodbye."
  end

  def create
    email_address = params[:email]

    user = User.find_by(email: email_address)
    if user
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to sessions_url #returning user successfully signed in 
      else
        redirect_to new_session_path(:error_msg => "Password does not match")
      end
    else
       redirect_to new_session_path(:error_msg => "Username does not exist")
    end
  end



end