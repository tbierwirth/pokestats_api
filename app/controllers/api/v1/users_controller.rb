class Api::V1::UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      response = {"api_key": @user.api_key}
      render json: response, status: :created
    else
      render json: "Email is not unique or passwords do not match", status: :bad_request
    end
  end

  private
  def user_params
    params.permit(:username, :password, :password_confirmation)
  end
end
