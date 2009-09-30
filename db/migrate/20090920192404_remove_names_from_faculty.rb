class RemoveNamesFromFaculty < ActiveRecord::Migration
  def self.up
    remove_column :faculty, :last_name
    remove_column :faculty, :first_name
  end

  def self.down
    add_column :faculty, :first_name, :string
    add_column :faculty, :last_name, :string
  end
end
