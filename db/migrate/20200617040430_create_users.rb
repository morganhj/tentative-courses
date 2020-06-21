class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.string :first_name
      t.string :last_name
      t.string :role
      t.string :mode
      t.string :level
      t.string :dates
      t.references :course, foreign_key: true

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
