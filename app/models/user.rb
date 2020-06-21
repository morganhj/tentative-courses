require 'pry-byebug'
class User < ApplicationRecord
	WEEKDAY = [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
	LEVELS = [:beginner, 
			:pre_intermediate, 
			:intermediate, 
			:upper_intermediate, 
			:advanced]
	enum levels: [:beginner, :pre_intermediate, :intermediate, :upper_intermediate, :advanced]
	enum modes: [:grouped, :single]
	belongs_to :course, optional: true

	# ==========================  INSTANCE METHODS  =================================

	def full_name
		return "#{self.first_name.capitalize} #{self.last_name.capitalize}"
	end

	#USER INSTANCE METHOD TO SEE IF THAT USER IS AVAILABLE ON THAT DATE AND TIME
	def can_attend(day, hr)
		dates = JSON.parse(self.dates)[day.to_s]
		first = (hr >= dates.first["from"].to_i && hr <= dates.first["to"].to_i - 1)
		last = (hr >= dates.last["from"].to_i && hr <= dates.last["to"].to_i - 1)
		return (first || last) && self.course.nil?
	end

	# ===============================================================================



	# =============================  CLASS METHODS  =================================

	# RETURNS A HASH WITH THE AMOUNT OF STUDENTS BY LEVEL FROM THE WHOLE POOL OF STUDENTS
	def self.students_by_level
		students = {
						beginner: 0, 
						pre_intermediate: 0, 
						intermediate: 0, 
						upper_intermediate: 0, 
						advanced: 0
					}
		self.where(role: "student", mode: "grouped", course: nil).each do |student|
			students[student.level.to_sym] = students[student.level.to_sym] += 1
		end
		return students
	end

	# RETURNS AN ARRAY WITH LENGTH NUMBER OF COURSES NECESSARY AND STUDENTS COUNT IN EACH COURSE.
	# EX. 7 BEGINNER STUDENTS WILL NEED 1 COURSE WITH 4 STUDENTS AND 1 COURSE WITH 3 STUDENTS. 
	def self.student_distributor(count)
		a = count / 6
		r = count % 6
		if r.zero?
			b = a 
		else
			b = a + 1
		end
		r = count % b
		c = count / b
		array = Array.new(b, c)
		r.times do |r|
			array[-(r+1)] += 1
		end
		return array
	end

	# RETURNS A HASH WITH COURSE COUNT BY LEVEL. HOW MANY COURSES OF EACH LVL SHOULD I HAVE??
	def self.course_distributor
		level_count = self.students_by_level
		answer = {}
		LEVELS.each do |level|
			count = level_count[level]
			array = self.student_distributor(count)
			answer[level] = array
		end
		return answer
	end

	# FIRST WE GET HOW MANY STUDENTS AND TEACHERS THAT ARE AVAILABLE FOR EVERY HOUR OF EVERY WEEKDAY
	# WE COUNT STUDENTS BY LEVEL IN EACH TIME SLOT
	def self.teachers_available_per_hour
		teachers = self.where(role: "teacher", course: nil)
		# DEFINE ARRAY TO STORE HASH WITH INFO FOR EVERY HOUR
		available_week = []
		WEEKDAY.map do |day|
		# FOR EVERY HOUR CREATE A HASH
			available_day = []
			24.times do |hr|
				hr += 1
				# INITIALIZE HOUR HASH WITH NUMBER OF USERS THAT CAN ATTEND, WITH THEIR RESPECTIVE LEVELS
				hour = { 
					hr: hr, 
					count: 0, 
					teachers: []
				}
				# FILL IN THE HOUR HASH WITH INFO ON EACH TEACHER
				teachers.each do |teacher|
					if teacher.can_attend(day, hr)
						# STORE USER INFO IN USER KEY OF HASH AND ADD COUNT FOR RESPECTIVE LEVEL
						hour[:teachers] = hour[:teachers] << teacher.id
						hour[:count] += 1
					end
				end
				# COUNT HOW MANY TEACHERS CAN GIVE CLASSES AT THAT HOUR
				available_day << hour
			end
			available_week << { day: day, hours: available_day.reject{ |hr| hr[:count].zero? } }
		end
		# REJECT HOURS WHERE STUDENTS CANT ATTEND
		return available_week
	end

	def self.students_available_per_hour(mode)
		students = self.where(role: "student", mode: mode, course: nil)
		# DEFINE ARRAY TO STORE HASH WITH INFO FOR EVERY HOUR
		available_week = []
		WEEKDAY.map do |day|
		# FOR EVERY HOUR CREATE A HASH
			available_day = []
			24.times do |hr|
				hr += 1
				# INITIALIZE HOUR HASH WITH NUMBER OF USERS THAT CAN ATTEND, WITH THEIR RESPECTIVE LEVELS
				hour = { 
					hr: hr, 
					count: 0, 
					students: [],
					levels: {
						beginner: 0, 
						pre_intermediate: 0, 
						intermediate: 0, 
						upper_intermediate: 0, 
						advanced: 0
					} 
				}
				# FILL IN THE HOUR HASH WITH INFO ON EACH STUDENT
				students.each do |student|
					if student.can_attend(day, hr)
						# STORE USER INFO IN USER KEY OF HASH AND ADD COUNT FOR RESPECTIVE LEVEL
						hour[:students] = hour[:students] << student.id
						hour[:levels][student.level.to_sym] += 1
					end
				end
				# COUNT HOW MANY STUDENTS CAN ATTEND CLASSES AT THAT HOUR
				hour[:count] += hour[:students].length
				available_day << hour
			end
			available_week << { day: day, hours: available_day.reject{ |hr| hr[:count].zero? } }
		end
		# REJECT HOURS WHERE STUDENTS CANT ATTEND
		return available_week
	end

	# RETURNS THE BEST HOURS OF THE WEEK FOR EACH LEVEL IN MODE: GROUPED AND SINGLE
	def self.candidate_hours(mode)
		available_students = self.students_available_per_hour(mode)
		available_teachers = self.where(role: "teacher", course: nil)
		# INITIALIZE ARRAY THAT WILL CONTAIN CANDIDATE HOURS FOR EACH LEVEL
		array = []
		levels=[:beginner, :pre_intermediate, :intermediate, :upper_intermediate, :advanced]
		levels.each do |level|
			week = []
			WEEKDAY.each do |week_day|
				# FOR EVERY LEVEL, RUN THE CLASS METHOD PREVIOUSLY DECLARED AND SORT THE RESULTS BY 
				# AMOUNT OF STUDENTS IN THOSE HOURS, GET THE TOP 3 BEST HOURS FOR THAT LEVEL
				student_hours = available_students.select{ |day| day[:day] == week_day }.first[:hours]
				s_sorted_hours = student_hours.sort_by{|hr| hr[:levels][level]}.reverse
				number_of_options = s_sorted_hours.length

				by_hour = []
				number_of_options.times do |n|
					teachers_by_option = []
					available_teachers.each do |teacher|
						if teacher.can_attend(week_day, s_sorted_hours[n][:hr])
							teachers_by_option << teacher.id
						end
					end
					if teachers_by_option.length > 0 && s_sorted_hours[n][:levels][level] > 0
						by_hour << { time: s_sorted_hours[n][:hr], student_count: s_sorted_hours[n][:levels][level], teacher_count: teachers_by_option.length }
					end
				end

				week << { 	
					level: level,
					week_day: week_day.to_s,
					# TOP 3 HOURS WITH THE AMOUNT OF STUDENTS FROM THAT LEVEL THAT CAN ATTEND
					hours: by_hour
				} unless by_hour.empty?
			end

			week = week.sort_by do |week_day| 
				[week_day[:hours][0][:student_count], -week_day[:hours][0][:teacher_count]] unless week_day[:hours].empty?
			end.reverse

			array << week unless week.empty?
		end

		array = array.sort_by do |level| 
			level[0][:hours][0][:student_count] unless level[0][:hours].empty?
		end.reverse

		return array
	end

	# CREATES COURSES AND ASSIGNS TEACHERS AND STUDENTS TO ZED COURSE. ¡¡¡THE BEST COURSES!!!
	def self.select_and_assign
		students = self.where(role: "student", mode: "grouped")
		teacher_availability = self.teachers_available_per_hour
		course_distributor = self.course_distributor
		candidate_hours = self.candidate_hours("grouped")
		# student_availability = self.students_available_per_hour
		# FOR EACH LEVEL ITERATE
		candidate_hours.map{|level| level[0][:level] }.each_with_index do |level, index|

			students_in_level = students.where(level: level)
			

			course_distributor[level].each do |n|

				option = 0
				course = Course.create!(mode: "grouped", level: level.to_s, capacity: n + 1)

				# ======= ASSIGN A TEACHER TO THAT COURSE =======
				while course.users.where(role: "teacher").empty?
					date = { week_day: candidate_hours[index][option][:week_day], time: candidate_hours[index][option][:hours][0][:time]}
					teachers_on_day = teacher_availability.select{ |week_day| week_day[:day].to_s == date[:week_day] }[0]
					teachers_on_time = teachers_on_day[:hours].select{ |time| time[:hr] == date[:time] }[0]
					if teachers_on_time[:count] > 0 
						teachers_on_time[:teachers].each do |id|
							teacher = User.find(id)
							if teacher.course.nil?
			
								teacher.update(course: course)
								course.update(dates: date.to_json)
								break
							end
						end
					end
					option += 1
				end
				# ===============================================

				students_in_level.where(course: nil).each do |student|
					if student.can_attend(date[:week_day],date[:time]) && !course.reached_intended_capacity?
						student.update(course: course)
					end
				end
			end
		end
		unassigned_teachers = self.where(role: "teacher", course: nil)
		single_students = self.where(role: "student", mode: "single", course: nil)
		single_students.each do |student|
			catch :assigned do 
				unassigned_teachers.each do |teacher|
					WEEKDAY.shuffle.each do |week_day|
						24.times do |hr|
							if student.can_attend(week_day, hr) && teacher.can_attend(week_day, hr)
								date = { week_day: week_day, time: hr }
								course = Course.create!(mode: "single", level: student.level.to_s, capacity: 2)

								student.update(course: course)
								teacher.update(course: course)
								course.update(dates: date.to_json)
								throw :assigned
							end
						end
					end
				end
			end
		end

		if self.where(role: "student", course: nil).count == 0
			return "All students are assigned to a course"
		else
			return "#{self.where(role: "student", course: nil).count} students are not assigned"
		end
	end

end
