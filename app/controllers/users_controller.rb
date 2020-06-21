class UsersController < ApplicationController
	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
	end

	private

	def user_params
		params.require(:user).permit(:first_name, :last_name, :role, :mode, :level, :dates, :course)
	end
end