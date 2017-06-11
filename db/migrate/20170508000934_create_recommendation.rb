class CreateRecommendation < ActiveRecord::Migration[5.1]
  def up
  	create_table :recommendations do |t|
      t.integer :subtopic_id
      t.string :first
      t.string :second
      t.string :third
      t.string :fourth
      t.timestamps
  	end
  end

  def down
  	drop_table :recommendations
  end
end
