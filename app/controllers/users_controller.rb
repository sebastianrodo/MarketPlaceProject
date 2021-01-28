class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :valid_account_owner!, only: [:update, :destroy]
  before_action :set_user, except: [:index, :new, :create]

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
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully created.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @users.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def destroy
    if valid_account_owner! || current_user.admin_role?
      @user.destroy

      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully deleted.' }
        format.json { head :no_content }
      end
    end
  end

  def update
    if valid_account_owner! || current_user.admin_role?
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to users_url, notice: 'User was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render :edit }
          format.json { render json: @users.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :cellphone, :address)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
