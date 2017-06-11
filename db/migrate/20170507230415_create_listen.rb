class CreateListen < ActiveRecord::Migration[5.1]
  def up
  	create_table :listens do |t|
      t.integer :subtopic_id
      t.string :subtopic_uuid
      t.datetime :listen_date
      t.string :user

      t.timestamps
  	end
  end

  def down
  	drop_table :listens
  end
end
