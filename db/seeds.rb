# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

WEEKDAY = [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
LEVELS= [:beginner, :pre_intermediate, :intermediate, :upper_intermediate, :advanced]
MODES= [:grouped, :single]

User.delete_all

30.times do |n|
	first_name = Faker::Name.first_name
	last_name = Faker::Name.last_name
	if [1,8,18,27].include?(n)
		mode = "single"
	else
		mode = "grouped"
	end
	dates = {}
	WEEKDAY.each do |day|
		dates[day] = [{ from: rand(8..10).to_s, to: rand(10..14).to_s }, { from: rand(14..18).to_s, to: rand(18..22).to_s }]	
	end

	user = User.create!(
		first_name: first_name, 
		last_name: last_name,
		email: Faker::Internet.email(name: "#{first_name.chars[0]} #{last_name}", separators: ''),
		role: "student",
		mode: mode,
		level: LEVELS.sample, 
		dates: dates.to_json
	)
	puts "#{n + 1}. #{user.full_name}"
end

10.times do |n|
	first_name = Faker::Name.first_name
	last_name = Faker::Name.last_name

	dates = {}
	WEEKDAY.each do |day|
		dates[day] = [{ from: rand(8..10).to_s, to: rand(10..14).to_s }, { from: rand(14..18).to_s, to: rand(18..22).to_s }]	
	end

	user = User.create!(
		first_name: first_name, 
		last_name: last_name,
		email: Faker::Internet.email(name: "#{first_name.chars[0]} #{last_name}", separators: ''),
		role: "teacher", 
		mode: "grouped",
		level: LEVELS.sample, 
		dates: dates.to_json
	)
	puts "#{n + 1}. #{user.full_name} / teacher"
end

# 4.times do |n|
# 	course = Course.create!(
# 		mode: ,
# 		level: ,
# 		teacher: ,
# 		students: ,
# 		dates: ,
# 		capacity:
# 	)
# 	puts "#{i + 1}. #{user.full_name}"
# end