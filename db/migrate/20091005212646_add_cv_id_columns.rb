class AddCvIdColumns < ActiveRecord::Migration
  def self.up
    add_column :patents, :cv_id, :integer
    add_column :grants, :cv_id, :integer
  end

  def self.down
    remove_column :patents, :cv_id
    remove_column :grants, :cv_id
  end
end
