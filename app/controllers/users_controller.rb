class UsersController < ApplicationController
  before_action :authenticate_user!
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
    else
      respond_to do |format|
        format.html { redirect_to users_url,
                      alert: 'The account you want to delete does not belong to you' }
      end
    end
  end

  def update
    if valid_account_owner! || current_user.admin_role?
      if @user.update(user_params)
        respond_to do |format|
          format.html { redirect_to users_url, notice: 'User was successfully updated.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.json { render json: @users.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = 'It was not updated, you are not this user.'
        format.html { render :edit }
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
