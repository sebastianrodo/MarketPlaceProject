class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :fetch_user, only: [:edit, :show, :destroy, :update, :archive]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User successfully created"
      redirect_to users_url
    else
      flash[:error] = "Something went wrong"
      render :new
    end
  end

  def show; end

  def destroy
    @user.destroy
    redirect_to users_url
  end

  def update
    if @user.id === current_user.id
      @user.update(user_params)

      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
      end
    else
      respond_to do |format|
        format.html { redirect_to users_url,
                      notice: 'It was not updated, you are not this user.' }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :cellphone, :address)
  end

  def fetch_user
    @user = User.find(params[:id])
  end
end
