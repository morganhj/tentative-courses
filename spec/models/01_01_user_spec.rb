require 'rails_helper'

RSpec.describe "User", :type => :model do

	let(:dates) do
		dates = {}
		WEEKDAY.each do |day|
			dates[day] = [{ from: rand(8..10).to_s, to: rand(10..14).to_s }, { from: rand(14..18).to_s, to: rand(18..22).to_s }]
		end
		return dates	
	end


	it "#full_name returns first name and last name capitalized" do
		user = User.new(
			first_name: "morgan", 
			last_name: "hoare",
			email: "mhoare@example.com",
			role: "student",
			mode: "grouped",
			level: "beginner", 
			dates: dates.to_json
			)
		expect(user.full_name).to eq("Morgan Hoare")
	end

	it "#can_attend should return a boolean" do
		expect(User.first.can_attend(:monday, 10)).to be_in([true, false])
	end

	it "#User.all should return 40 counts" do
		expect(User.all.count).to eq(40)
	end

	it "#User.students_by_level should return a hash" do
		expect(User.students_by_level).to be_a(Hash)
	end

	it "#User.students_available_per_hour should return an array" do
		expect(User.students_available_per_hour("grouped")).to be_a(Array)
	end

	it "#User.teachers_available_per_hour should return an array" do
		expect(User.teachers_available_per_hour).to be_a(Array)
	end

	it "#User.candidate_hours should return an array" do
		expect(User.candidate_hours("grouped")).to be_a(Array)
	end

	it "#User.select_and_assign should return an string" do
		expect(User.select_and_assign).to be_a(String)
	end

	it "#User.select_and_assign should return 'All students are assigned to a course' if everything went OK" do
		expect(User.select_and_assign).to eq('All students are assigned to a course')
	end

	
end

