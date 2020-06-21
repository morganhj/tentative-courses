RSpec.describe "Course", :type => :model do
	let(:dates) do
		dates = {}
		WEEKDAY.each do |day|
			dates[day] = [{ from: rand(8..10).to_s, to: rand(10..14).to_s }, { from: rand(14..18).to_s, to: rand(18..22).to_s }]
		end
		return dates	
	end

	it "#reached_intended_capacity? should return true if intended capacity has been reached" do
		test_course = Course.create!(level: "beginner", mode: "grouped", capacity: 5)
		5.times do |n|
			first_name = Faker::Name.first_name
			last_name = Faker::Name.last_name
			if n == 0
				role = "teacher"
			else
				role = "student"
			end
			User.create!(
				first_name: first_name, 
				last_name: last_name,
				email: Faker::Internet.email(name: "#{first_name.chars[0]} #{last_name}", separators: ''),
				role: role, 
				mode: "grouped",
				level: "beginner", 
				dates: dates.to_json,
				course: test_course
			)
		end
		expect(test_course.reached_intended_capacity?).to be(true)
	end

	it "#full? should return true if max permitted users per course is reached" do
		test_course = Course.create!(level: "beginner", mode: "grouped")
		7.times do |n|
			first_name = Faker::Name.first_name
			last_name = Faker::Name.last_name
			User.create!(
				first_name: first_name, 
				last_name: last_name,
				email: Faker::Internet.email(name: "#{first_name.chars[0]} #{last_name}", separators: ''),
				role: "student", 
				mode: "grouped",
				level: "beginner", 
				dates: dates.to_json,
				course: test_course
			)
		end
		expect(test_course.full?).to be(true)
	end
end
