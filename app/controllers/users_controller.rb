class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews_as_reviewee
  end
end
