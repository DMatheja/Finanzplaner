class UsersController < ApplicationController
  before_action :authorize_admin, except: [:show, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @users = User.all
  end
  
  def show
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'User created successfully'
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    authorize_owner(@user) unless current_user&.admin?
    if @user.update(user_params)
      redirect_to @user, notice: 'User updated successfully'
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User deleted successfully'
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
