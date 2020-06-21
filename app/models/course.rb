class Course < ApplicationRecord
	has_many :users

	def teacher
		self.users.where(role: "teacher").first
	end

	def reached_intended_capacity?
		answer = false
		if self.capacity
			answer = self.users.count >= self.capacity
		end
		return answer
	end

	def full?
		self.users.count >= 7
	end
end
