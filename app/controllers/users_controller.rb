class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :fetch_user, except: [:index, :new, :create]

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
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def show; end

  def destroy
    respond_to do |format|
      if valid_account_owner! || current_user.admin_role?
        @user.destroy

        format.html { redirect_to users_url, notice: 'User was successfully deleted.' }
      else
        format.html { redirect_to users_url,
                      alert: 'The account you want to delete does not belong to you' }
      end
    end
  end

  def update
    respond_to do |format|
      if valid_account_owner! || current_user.admin_role?
        if @user.update(user_params)
          format.html { redirect_to users_url, notice: 'User was successfully updated.' }
        else
          format.html { render :edit }
        end
      else
        flash.now[:alert] = 'It was not updated, you are not this user.'
        format.html { render :edit }
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
