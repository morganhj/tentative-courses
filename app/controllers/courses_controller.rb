class CoursesController < ApplicationController
	def index
		@courses = Course.all
	end

	def show
		@course = Course.find(params[:id])
	end

	def new
		@course = Course.new
	end

	def create
		@course = Course.new(course_params)
	end

	private

	def course_params
		params.require(:course).permit(:mode, :level, :dates, :capacity)
	end
end
