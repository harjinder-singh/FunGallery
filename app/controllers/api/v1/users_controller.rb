class Api::V1::UsersController < ApplicationController

  before_action :authenticate_with_token!, only: [:update, :destroy]

  def index
    render json: User.all
  end

  def show
    user = User.find_by(id: params[:id])
    if user
      render json: user
    else
      render json: { errors: 'record not found' }, status: 422
    end
  end

  def create
    user = User.new(user_params)
    
    if user.save
      render json: user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    current_user.destroy
    head 204
  end


  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end