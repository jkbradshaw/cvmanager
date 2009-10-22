class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :start_year
      t.integer :end_year
      t.string :title
      t.string :organization
      t.text :description
      t.string :type
      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
