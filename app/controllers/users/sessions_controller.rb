class Users::SessionsController < Devise::SessionsController

  def create
    user_password = params[:user_password]
    user_email = params[:user_email]
    user = user_email.present? && User.find_by(email: user_email)

    if user
      if user.valid_password? user_password
        sign_in user, store: false
        user.generate_authentication_token!
        user.save
        render json: user, root: :user, status: 200, location: [:api, user]
      else
        render json: { errors: "Invalid email or password" }, status: 422
      end
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

  def destroy
    respond_to do |format|
      format.html { super }
      format.json {
        warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
        render :json => {}.to_json, :status => :ok
      }
    end
  end

end
