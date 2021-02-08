# frozen_string_literal: true

# users controller
class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i[new create]
  before_action :fetch_user, except: %i[index new create]
  before_action :valid_account_owner!, only: %i[update destroy]

  def index
    @users = User.all
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def update
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

  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :first_name, :last_name, :email, :cellphone, :address)
  end

  def fetch_user
    @user = User.find(params[:id])
  end
end
