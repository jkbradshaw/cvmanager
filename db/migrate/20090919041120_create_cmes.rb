class CreateCmes < ActiveRecord::Migration
  def self.up
    create_table :cmes do |t|
      t.string :source
      t.integer :user_id
      t.date :received_date
      t.integer :hours
      t.integer :cme_category_id
      t.timestamps
    end
  end

  def self.down
    drop_table :cmes
  end
end
