class CreateUserVisits < ActiveRecord::Migration
  def change
    create_table :user_visits do |t|
      t.integer :user_id
      t.integer :country_id

      t.timestamps
    end
  end
end
