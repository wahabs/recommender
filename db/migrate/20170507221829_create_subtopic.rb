class CreateSubtopic < ActiveRecord::Migration[5.1]
  def up
  	create_table :subtopics do |t|
      t.string :uuid, null: false
  		t.string :name
      t.text :description

      t.timestamps
  	end
    add_index :subtopics, :uuid, unique: true
  end

  def down
  	drop_table :subtopics
  end
end
