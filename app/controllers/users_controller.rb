# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_access, only: [:edit, :update, :destroy, :index]

  def dashboard
    @user = current_user
    @categories = @user.categories
  end

  def index
    @users = User.all
  end

  def show
    authorize_user_access
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit
    authorize_user_access
  end

  def update
    authorize_user_access
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize_user_access
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_access
    unless current_user.admin? || current_user.test_admin?
      redirect_to root_path, alert: 'You do not have permission to perform this action.'
    end
  end

  def authorize_user_access
    unless current_user.admin? || current_user.test_admin? || current_user.id == @user.id
      redirect_to root_path, alert: 'You can only edit your own profile.'
    end
  end

  def user_params
    allowed_params = [:name, :balance, :income, :income_day, :password, :password_confirmation]
    allowed_params << :role if current_user.admin? || current_user.test_admin?
    params.require(:user).permit(*allowed_params)
  end
end