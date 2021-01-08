class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User successfully created"
      redirect_to users_url
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_url
    else
      redirect_to users_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :cellphone, :address)
  end
end
