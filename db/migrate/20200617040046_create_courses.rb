class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :mode
      t.string :level
      t.string :dates
      t.integer :capacity

      t.timestamps
    end
  end
end
