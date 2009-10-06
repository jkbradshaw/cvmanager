class CreatePatents < ActiveRecord::Migration
  def self.up
    create_table :patents do |t|
      t.integer :year
      t.text :description
      t.string :number
      t.string :title
      t.timestamps
    end
  end

  def self.down
    drop_table :patents
  end
end
