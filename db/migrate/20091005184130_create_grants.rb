class CreateGrants < ActiveRecord::Migration
  def self.up
    create_table :grants do |t|
      t.date :start_date
      t.date :end_date
      t.integer :direct_award
      t.integer :indirect_award
      t.integer :status_id, :default => 1
      t.text :awarded_by
      t.text :description
      t.string :role
      t.integer :number
      t.string :title
      t.timestamps
    end
  end

  def self.down
    drop_table :grants
  end
end
